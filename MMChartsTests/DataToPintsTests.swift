//
//  DataToPintsTests.swift
//  MMChartsTests
//
//  Created by MIGUEL MOLDES on 13/7/19.
//  Copyright © 2019 MIGUEL MOLDES. All rights reserved.
//

import Foundation
import XCTest

@testable import MMCharts

class DataToPointsTests: XCTestCase {
    
    func testDataToPoints() {
        let minX:CGFloat = 1.0
        let maxX:CGFloat = 31.0
        let minY:CGFloat = 0.0
        let maxY:CGFloat = 120.0
        let extremeValues = GraphHelperExtremeValues(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
        
        let sut = DataToPoints(extremeValues: extremeValues)
        
        let list:[(CGFloat,CGFloat)] = [
            (1.0,10.0),
            (2.0,12.0),
            (3.0,24.0),
            (30.0, 81.0),
            (31.0,120.0)
        ]
        
        var rectHeight: CGFloat = 140.0
        var rectWidth: CGFloat = 120.0
        var rect = CGRect(x: 0.0, y: 0.0, width: rectWidth, height: rectHeight)
        var points = sut.calculatePositions(list: list, rect: rect)
        
        func finalYPos(value: CGFloat) -> CGFloat {
            return (rectHeight / (maxY - minY)) * (maxY - value)
        }
        
        func finalXPos(value: CGFloat) -> CGFloat {
            return (rectWidth / (maxX - minX)) * (value - minX)
        }
        
        XCTAssertEqual(points, list.compactMap { CGPoint(x: finalXPos(value: $0.0), y: finalYPos(value: $0.1))})
        
        rectHeight = 1350.0
        rectWidth = 1880.0
        rect = CGRect(x: 0.0, y: 0.0, width: rectWidth, height: rectHeight)
        
        points = sut.calculatePositions(list: list, rect: rect)
        XCTAssertEqual(points, list.compactMap { CGPoint(x: finalXPos(value: $0.0), y: finalYPos(value: $0.1))})
    }
    
}

