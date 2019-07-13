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

class LineGraphLayer: GraphLayer {
    
    private let color: UIColor
    
    var points = [CGPoint]()
    var linePathWidth: CGFloat
    
    init(color: UIColor = UIColor.blue, linePathWidth: CGFloat = 1.0) {
        self.color = color
        self.linePathWidth = linePathWidth
        super.init()
    }
    
    override func drawLayer(rect:CGRect) {
        super.drawLayer(rect: rect)
        guard self.points.count > 0 else {
            return 
        }
        //layer.isHidden = true
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.fillColor = UIColor.clear.cgColor
        
        self.path.contractionFactor = CGFloat(0.7)
        self.path.move(to:points[0])
        self.path.addBezierThrough(points: points)
        self.layer.lineWidth = self.linePathWidth
        self.layer.strokeColor = self.color.cgColor
        self.layer.path = self.path.cgPath
        
        layer.lineCap = CAShapeLayerLineCap.round
        
        // for a short moment it shows the original fill color. Workaround:
//        delayWithSeconds(0.5, completion: {
//            self.layer.isHidden = false
//            //            self.animate()
//        })
    }
    
}
