//
//  LineGraphLayer.swift
//  MMCharts
//
//  Created by MIGUEL MOLDES on 16/6/19.
//  Copyright © 2019 MIGUEL MOLDES. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class GraphCurvesLayer: GraphLayer {
    
    static let identifier: String = "curve"
    
    private let color: UIColor
    private let linePathWidth: CGFloat
    
    var points = [CGPoint]()
    
    init(color: UIColor = UIColor.blue, linePathWidth: CGFloat = 3.0) {
        self.color = color
        self.linePathWidth = linePathWidth
        super.init()
        self.layer.name = GraphCurvesLayer.identifier
    }
    
    override func drawLayer(rect:CGRect) {
        super.drawLayer(rect: rect)
        guard self.points.count > 0 else {
            return 
        }
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.fillColor = UIColor.clear.cgColor
        
        self.path.contractionFactor = CGFloat(0.7)
        self.path.move(to:points[0])
        self.path.addBezierThrough(points: points)
        self.layer.lineWidth = self.linePathWidth
        self.layer.strokeColor = self.color.cgColor
        self.layer.path = self.path.cgPath
        
        layer.lineCap = CAShapeLayerLineCap.round
    }
    
}
