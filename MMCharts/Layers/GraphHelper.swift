//
//  GraphHelper.swift
//  MMCharts
//
//  Created by Miguel Moldes on 22/07/2019.
//  Copyright © 2019 MIGUEL MOLDES. All rights reserved.
//

import Foundation
import CoreGraphics

enum AxisOrientation: Int {
    case x, y
}

struct GraphHelperExtremeValues {
    let minX: CGFloat
    let maxX: CGFloat
    let minY: CGFloat
    let maxY: CGFloat
}

class GraphHelper {
    
    static func getPoints(rect: CGRect, list: [(CGFloat, CGFloat)], extremeValues: GraphHelperExtremeValues) -> [CGPoint] {
        let dataToPoints = DataToPoints(extremeValues: extremeValues)
        return dataToPoints.calculatePositions(list: list, rect: rect)
    }
    
    static func getExtremeValues(values: [(CGFloat, CGFloat)]) -> GraphHelperExtremeValues {
        return GraphHelperExtremeValues(minX: GraphHelper.getLowestXValue(values: values),
                                        maxX: GraphHelper.getBiggestXValue(values: values),
                                        minY: GraphHelper.getLowestYValue(values: values),
                                        maxY: GraphHelper.getBiggestYValue(values: values))
    }
    
    static func getLowestYValue(values: [(CGFloat, CGFloat)]) -> CGFloat {
        var lowest: CGFloat = CGFloat.greatestFiniteMagnitude
        for value in values {
            if value.1 < lowest {
                lowest = value.1
            }
        }
        return lowest
    }
    
    static func getBiggestYValue(values: [(CGFloat, CGFloat)]) -> CGFloat {
        var biggest: CGFloat = 0.0
        for value in values {
            if value.1 > biggest {
                biggest = value.1
            }
        }
        return biggest
    }
    
    static func getLowestXValue(values: [(CGFloat, CGFloat)]) -> CGFloat {
        var lowest: CGFloat = CGFloat.greatestFiniteMagnitude
        for value in values {
            if value.0 < lowest {
                lowest = value.0
            }
        }
        return lowest
    }
    
    static func getBiggestXValue(values: [(CGFloat, CGFloat)]) -> CGFloat {
        var biggest: CGFloat = 0.0
        for value in values {
            if value.0 > biggest {
                biggest = value.0
            }
        }
        return biggest
    }
    
}
