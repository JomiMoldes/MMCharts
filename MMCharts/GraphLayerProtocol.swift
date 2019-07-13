//
//  GraphLayerProtocol.swift
//  MMCharts
//
//  Created by MIGUEL MOLDES on 16/6/19.
//  Copyright © 2019 MIGUEL MOLDES. All rights reserved.
//

import Foundation
import QuartzCore

protocol GraphLayerProtocol {
    
    var layer : CAShapeLayer { get }
    
    func drawLayer(rect:CGRect)
    
    func clean()
    
}
