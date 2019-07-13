//
//  DataToPoints.swift
//  MMCharts
//
//  Created by MIGUEL MOLDES on 13/7/19.
//  Copyright © 2019 MIGUEL MOLDES. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class DataToPoints {
    
    private let xMin: CGFloat
    private let xMax: CGFloat
    private let yMin: CGFloat
    private let yMax: CGFloat
    private let insets: UIEdgeInsets
    
    init(xMin: CGFloat, xMax: CGFloat, yMin: CGFloat, yMax: CGFloat, margins: UIEdgeInsets) {
        self.xMin = xMin
        self.xMax = xMax
        self.yMin = yMin
        self.yMax = yMax
        self.insets = margins
    }
    
    func calculatePositions(list:[(CGFloat,CGFloat)], rect: CGRect) -> [CGPoint] {
        guard rect.width > self.insets.left + self.insets.right else {
            return [CGPoint]()
        }
        var points = [CGPoint]()
        var xPos:CGFloat = 0
        var yPos:CGFloat = rect.height
        
        for i in 0..<list.count {
            let element:(CGFloat,CGFloat) = list[i]
            xPos = self.xPos(for: element.0, rect: rect)
            yPos = self.yPos(for: element.1, rect: rect)
            points.append(CGPoint(x: xPos, y: yPos))
        }
        
        return points
    }
    
    private func xPos(for element: CGFloat, rect: CGRect) -> CGFloat {
        let graphWidth: CGFloat = rect.size.width - self.insets.left - self.insets.right
        let unitsDistance: CGFloat = element - self.xMin
        let distance: CGFloat = unitsDistance * (graphWidth / (self.xMax - self.xMin))
        return distance + self.insets.left
    }
    
    private func yPos(for element: CGFloat, rect: CGRect) -> CGFloat {
        let graphHeight: CGFloat = rect.height - self.insets.top - self.insets.bottom
        let unitsDistance: CGFloat = self.yMax - element
        let distance: CGFloat = unitsDistance * (graphHeight / (self.yMax - self.yMin))
        return distance + self.insets.top

    }
    
}
