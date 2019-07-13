//
//  MultiplierForAnimation.swift
//  MMCharts
//
//  Created by MIGUEL MOLDES on 13/7/19.
//  Copyright © 2019 MIGUEL MOLDES. All rights reserved.
//

import Foundation
import CoreGraphics

class MultiplierForAnimation {
    
    func multiply(from:[(CGFloat,CGFloat)], to: [(CGFloat,CGFloat)]) -> [[(CGFloat,CGFloat)]] {
        var finalElements: [[(CGFloat,CGFloat)]] = [from]
        var secondList = [(CGFloat, CGFloat)]()
        
        var fromPosition:Int = 0
        var toPosition:Int = 0
        var index: Int = 0
        while index < from.count {
            index += 1
            let firstElement = self.getFirstElement(from: from, to: to, fromPosition: fromPosition, toPosition: toPosition)
            let firstPoint = firstElement.0
            
            if firstElement.1 == false {
                secondList.append(firstPoint)
                toPosition += 1
                index -= 1
                continue
            }
            fromPosition += 1
            let previousItem = self.getPreviousItem(to: to, value: firstPoint.0)
            
            if previousItem.0 == firstPoint.0 {
                secondList.append(convertPoint(from: firstPoint, to: previousItem))
                toPosition += 1
                continue
            }
            
            if let nextItem = self.getNextItem(to: to, value: firstPoint.0) {
                secondList.append(convertPoint(previous: previousItem, next: nextItem, to: firstPoint))
                continue
            }
            secondList.append(firstPoint)
        }
        
        for _ in toPosition..<to.count {
            secondList.append(to[toPosition])
        }
        
        
        finalElements.append(secondList)
        finalElements.append(to)
        return finalElements
    }
    
    private func getFirstElement(from:[(CGFloat,CGFloat)], to: [(CGFloat,CGFloat)], fromPosition: Int, toPosition:Int) -> ((CGFloat, CGFloat), Bool) {
        guard toPosition < to.count else {
            return (from[fromPosition], true)
        }
        if from[fromPosition].0 <= to[toPosition].0 {
            return (from[fromPosition], true)
        }
        return (to[toPosition], false)
    }
    
    private func getPreviousItem(to:[(CGFloat, CGFloat)], value: CGFloat) -> (CGFloat, CGFloat) {
        var element = to[0]
        for i in 0..<to.count {
            let fromElement = to[i]
            if fromElement.0 <= value {
                element = fromElement
                continue
            }
            return element
        }
        return element
    }
    
    private func getNextItem(to:[(CGFloat, CGFloat)], value: CGFloat) -> (CGFloat, CGFloat)? {
        for i in 0..<to.count {
            let fromElement = to[i]
            if fromElement.0 > value {
                return fromElement
            }
        }
        return nil
    }
    
    private func convertPoint(from: (CGFloat, CGFloat), to: (CGFloat, CGFloat)) -> (CGFloat, CGFloat) {
        return (from.0, (from.1 + to.1) / 2)
    }
    
    private func convertPoint(previous: (CGFloat, CGFloat), next: (CGFloat, CGFloat), to: (CGFloat, CGFloat)) -> (CGFloat, CGFloat) {
        let xDistance = next.0 - previous.0
        if previous.1 > next.1 {
            let yDistance = previous.1 - next.1
            let xDistanceBetweenCurrentAndPreviousOne = to.0 - previous.0
            let yTarget = previous.1 - (xDistanceBetweenCurrentAndPreviousOne * (yDistance / xDistance))
            return (to.0, yTarget)
        }
        let yDistance = next.1 - previous.1
        let xDistanceBetweenCurrentAndPreviousOne = to.0 - previous.0
        let yTarget = previous.1 + (xDistanceBetweenCurrentAndPreviousOne * (yDistance / xDistance))
        return (to.0, yTarget)
    }
    
}
