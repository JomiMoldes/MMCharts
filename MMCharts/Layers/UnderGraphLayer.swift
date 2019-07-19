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

class UnderGraphLayer: GraphLayer {
    
    var counter = 0
    
    var pathMask = UIBezierPath()
    
    var maskLayer = CAShapeLayer()
    var gradient = CAGradientLayer()
    
    //let margins: UIEdgeInsets
    let underWeightBgColor: UIColor
    let linePathWidth: CGFloat
    var points = [CGPoint]()
    
    init(/*margins: UIEdgeInsets, */underWeightBgColor: UIColor = UIColor.blue, linePathWidth: CGFloat = 1.0) {
        //self.margins = margins
        self.underWeightBgColor = underWeightBgColor
        self.linePathWidth = linePathWidth
        super.init()
    }
    
    override func drawLayer(rect: CGRect) {
        super.drawLayer(rect: rect)
        maskLayer.path = nil
        //        maskLayer = CAShapeLayer()
        pathMask = UIBezierPath()
        drawOverClippingArea(rect: rect)
    }
    
    func drawOverClippingArea(rect: CGRect){
        //let model = self.model
        //let points = model.graphPoints()
        guard points.count > 1 else {
            return
        }
        
        
        //        self.maskLayerByZone()
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.createGradientLayer(rect: rect)
//        animate()
    }
    
    private func createGradientLayer(rect: CGRect) {
        gradient = CAGradientLayer()
        self.maskGradientLayer(gradient:gradient, rect: rect)
        gradient.frame = rect
        gradient.colors = [self.underWeightBgColor.withAlphaComponent(0.5).cgColor,
                           self.underWeightBgColor.withAlphaComponent(0.1).cgColor
        ]
        gradient.locations = [0.65, 0.85]
//        calculateGradientPoints(gradient, rect: rect)
        
        
        
        
        self.layer.addSublayer(gradient)
    }
    
    private func maskGradientLayer(gradient:CAGradientLayer, rect: CGRect) {
        //let points = self.model.graphPoints()
        
        guard points.count > 0 else {
            return
        }
        
        let firstWeightPoint = points[0]
        path.contractionFactor = CGFloat(0.7)
        path.move(to:firstWeightPoint)
        path.addBezierThrough(points: points)
        path.addLine(to: CGPoint(x:points[points.count - 1].x,y: rect.height/* - self.margins.bottom*/))
        path.addLine(to:CGPoint(x:firstWeightPoint.x,
                                y:rect.height /*- self.margins.bottom*/))
        path.addLine(to: firstWeightPoint)
        
        
        
        self.path.lineWidth = self.linePathWidth
        self.path.close()
        self.path.addClip()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = self.path.cgPath
        
        gradient.mask = maskLayer
    }
    
//    private func maskLayerByZone() {
//        pathMask.move(to: CGPoint(x:self.model.goalGraphPoints.p1.x,
//                                  y:self.model.graphRect.height - self.model.bottomMargin))
//        pathMask.addLine(to: CGPoint(x: self.model.goalGraphPoints.p1.x, y: 0))
//        pathMask.addLine(to: CGPoint(x: self.model.graphRect.size.width, y: 0))
//
//        pathMask.addLine(to: CGPoint(x: self.model.graphRect.size.width, y: self.model.graphRect.height - self.model.bottomMargin))
//        pathMask.addLine(to: CGPoint(x: self.model.goalGraphPoints.p1.x, y: self.model.graphRect.height - self.model.bottomMargin))
//        pathMask.close()
//        pathMask.addClip()
//        maskLayer.path = pathMask.cgPath
//
//        self.layer.mask = maskLayer
//    }
    
//    private func calculateGradientPoints(_ gradient:CAGradientLayer, rect: CGRect) {
//        let goal1 = self.model.goalGraphPoints.p1
//        let goal2 = self.model.goalGraphPoints.p2
//
//        let totalHeight = rect.size.height - self.margins.bottom - self.margins.top
//        let distanceToP1 = goal1.y - self.margins.top
//        let proportion1 = distanceToP1 / totalHeight
//
//        let distanceToP2 = goal2.y - self.margins.top
//        let proportion2 = distanceToP2 / totalHeight
//
//        let lastYVariation = (proportion2 == 1) ? 0 : (1 - proportion2) / 2
//        let firstYVariation = (proportion1 == 0) ? 0 : proportion1 / 2
//        let startX = 1 - lastYVariation - firstYVariation
//
//        let endX = 1 - startX
//
//        gradient.startPoint = CGPoint(x:startX, y: 0)
//        gradient.endPoint = CGPoint(x:endX , y:1)
//    }
    
    private func animate() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 4.7
        self.layer.add(animation, forKey: "strokeEndAnimation")
    }
    
    override func clean() {
        super.clean()
        self.doClean(layer: self.maskLayer)
        self.doClean(layer: self.gradient)
        self.pathMask.removeAllPoints()
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

