//
//  GraphLayer.swift
//  MMCharts
//
//  Created by MIGUEL MOLDES on 16/6/19.
//  Copyright © 2019 MIGUEL MOLDES. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class GraphLayer: GraphLayerProtocol {
    
    let layer = CAShapeLayer()
    private (set) var path = UIBezierPath()
    
    func drawLayer(rect: CGRect) {
        self.layer.frame = rect
        self.path = UIBezierPath()
    }
    
    func clean() {
        self.cleanLayer(layer: self.layer)
    }
    
    func cleanLayer(layer:CALayer) {
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
