//
//  GraphLabelsLayer.swift
//  MMCharts
//
//  Created by Miguel Moldes on 19/07/2019.
//  Copyright © 2019 MIGUEL MOLDES. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit
import CoreGraphics

struct GraphLabelLayerValue {
    let orientation: AxisOrientation
    let point: CGPoint
    let title: String
}

class GraphLabelsLayer : GraphLayer {
    
    private let margins: UIEdgeInsets
    private let model: GraphLabelsLayerModel
    
    init(margins: UIEdgeInsets, model: GraphLabelsLayerModel) {
        self.margins = margins
        self.model = model
    }
    
    override func drawLayer(rect: CGRect) {
        super.drawLayer(rect: rect)
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.addLabel(rect)
    }
    
    private func addLabel(_ rect: CGRect) {
        
        for label in self.model.labels {
            let textLayer = CATextLayer()
            let width = label.orientation == .y ? self.margins.left : self.model.labelWidth

            let point = label.orientation == .y ?
                CGPoint(x: label.point.x - self.model.leftPadding, y: label.point.y + self.margins.top - (self.model.labelHeight / 2)) :
                CGPoint(x: label.point.x + self.margins.left - (width / 2), y: rect.height - self.margins.bottom + self.model.bottomPadding)

            textLayer.frame = CGRect(origin: point, size: CGSize(width: width, height: self.model.labelHeight))
            
            let attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: self.model.labelHeight - 2),
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
            let bottomValueAttString = NSAttributedString(string: label.title, attributes: attributes)
            textLayer.string = bottomValueAttString
            self.layer.addSublayer(textLayer)
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.alignmentMode = label.orientation == .y ? CATextLayerAlignmentMode.right : CATextLayerAlignmentMode.center
        }
        
    }
    
}

class GraphLabelsLayerModel {
    
    let labels: [GraphLabelLayerValue]
    let labelHeight: CGFloat = 9.0
    let labelWidth: CGFloat = 20.0
    let leftPadding: CGFloat = 15.0
    let bottomPadding: CGFloat = 15.0
    
    init(values: [(CGFloat, CGFloat)], rect: CGRect, extremeValues: GraphHelperExtremeValues) {
        
        let yValues: [(CGFloat, CGFloat)] = [
            (extremeValues.minX, extremeValues.minY),
            (extremeValues.minX, extremeValues.maxY / 2),
            (extremeValues.minX, extremeValues.maxY)
        ]
        let yPoints = GraphHelper.getPoints(rect: rect, list: yValues, extremeValues: extremeValues)
        
        var xValues: [(CGFloat, CGFloat)] = [
            (1.0, 0.0),
            (7.0, 0.0),
            (14.0, 0.0),
            (21.0, 0.0),
            (28.0, 0.0)
        ]
        if extremeValues.maxX > 28.0 {
            xValues.append((extremeValues.maxX, 0.0))
        }
        let xPoints = GraphHelper.getPoints(rect: rect, list: xValues, extremeValues: extremeValues)
        var labels = [GraphLabelLayerValue]()
        for i in 0..<yPoints.count {
            let point = yPoints[i]
            let values = yValues[i]
            labels.append(GraphLabelLayerValue(orientation: .y, point: point, title: "\(values.1)"))
        }
        
        for i in 0..<xPoints.count {
            let point = xPoints[i]
            let values = xValues[i]
            labels.append(GraphLabelLayerValue(orientation: .x, point: point, title: "\(Int(values.0))"))
        }
        self.labels = labels
    }
}
