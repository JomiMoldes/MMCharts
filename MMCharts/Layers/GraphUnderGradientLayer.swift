//
//  UnderGraphLayer.swift
//  MMCharts
//
//  Created by MIGUEL MOLDES on 14/7/19.
//  Copyright © 2019 MIGUEL MOLDES. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class GraphUnderGradientLayer: GraphLayer {
    
    static let identifier: String = "under"
    
    private var pathMask = UIBezierPath()
    private var maskLayer = CAShapeLayer()
    private var gradient = CAGradientLayer()
    private let underWeightBgColor: UIColor
    private let linePathWidth: CGFloat
    
    var points = [CGPoint]()
    
    init(underWeightBgColor: UIColor = UIColor.blue, linePathWidth: CGFloat = 1.0) {
        self.underWeightBgColor = underWeightBgColor
        self.linePathWidth = linePathWidth
        super.init()
        self.layer.name = GraphUnderGradientLayer.identifier
    }
    
    override func drawLayer(rect: CGRect) {
        super.drawLayer(rect: rect)
        self.maskLayer.path = nil
        self.pathMask = UIBezierPath()
        self.drawOverClippingArea(rect: rect)
    }
    
    func drawOverClippingArea(rect: CGRect){
        guard self.points.count > 1 else {
            return
        }
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.createGradientLayer(rect: rect)
    }
    
    private func createGradientLayer(rect: CGRect) {
        self.gradient = CAGradientLayer()
        self.maskGradientLayer(gradient:gradient, rect: rect)
        self.gradient.frame = CGRect(x: 0.0, y: 0.0, width: rect.width, height: rect.height)
        self.gradient.colors = [self.underWeightBgColor.withAlphaComponent(0.3).cgColor,
                           self.underWeightBgColor.withAlphaComponent(0.0).cgColor
        ]
        self.gradient.locations = [0.45, 1.0]
        self.layer.addSublayer(self.gradient)
    }
    
    private func maskGradientLayer(gradient:CAGradientLayer, rect: CGRect) {
        guard self.points.count > 0 else {
            return
        }
        
        let firstWeightPoint = self.points[0]
        self.path.contractionFactor = CGFloat(0.7)
        self.path.move(to: firstWeightPoint)
        self.path.addBezierThrough(points: self.points)
        self.path.addLine(to: CGPoint(x: self.points[self.points.count - 1].x,y: rect.height))
        self.path.addLine(to: CGPoint(x: firstWeightPoint.x,
                                y: rect.height))
        self.path.addLine(to: firstWeightPoint)

        self.path.lineWidth = self.linePathWidth
        self.path.close()
        self.path.addClip()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = self.path.cgPath
        
        self.gradient.mask = maskLayer
    }
    
    override func clean() {
        super.clean()
        self.pathMask.removeAllPoints()
        self.doClean(layer: self.maskLayer)
        self.doClean(layer: self.gradient)
    }
    
    private func doClean(layer:CALayer) {
        guard let layers = layer.sublayers else {
            (layer as? CAShapeLayer)?.path = nil
            layer.mask = nil
            return
        }
        layers.forEach {
            let layer = $0
            (layer as? CAShapeLayer)?.path = nil
            layer.mask = nil
            self.cleanLayer(layer: layer)
            layer.removeFromSuperlayer()
        }
    }
}

