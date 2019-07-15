//
//  ViewController.swift
//  MMCharts
//
//  Created by MIGUEL MOLDES on 16/6/19.
//  Copyright © 2019 MIGUEL MOLDES. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let chartView = UIView()
    private var lineLayer: LineGraphLayer!
    private var gridLayer: GridLayer!
    private var axisLayer: AxisGraphLayer!
    private var underLayer: UnderGraphLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(chartView)
        
        self.view.backgroundColor = UIColor.white
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        chartView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        chartView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        chartView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        chartView.backgroundColor = UIColor.gray
        
        chartView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
        //self.animate(layer.layer)
    }
    
    @objc private func tapped(_: UITapGestureRecognizer) {
        self.reDrawGraphic()
    }
    
    var index: Int = 0
    private func reDrawGraphic() {
        index = index == 0 ? 1 : 0
        
        self.gridLayer?.clean()
        let graphInsets = UIEdgeInsets(top: 20.0, left: 40.0, bottom: 20.0, right: 40.0)
        self.gridLayer = GridLayer(margins: graphInsets, gridColor: UIColor.red.withAlphaComponent(0.4))
        self.chartView.layer.addSublayer(self.gridLayer.layer)
        self.gridLayer.drawLayer(rect: self.chartView.bounds)
        
        
        self.axisLayer?.clean()
        self.axisLayer = AxisGraphLayer(margins: graphInsets)
        self.chartView.layer.addSublayer(self.axisLayer.layer)
        self.axisLayer.drawLayer(rect: self.chartView.bounds)
        
        let multiplier = MultiplierForAnimation()
        let lists = multiplier.multiply(from: ViewController.lists[index], to: ViewController.lists[index == 0 ? 1 : 0], times: 10)
        
        let frameWithMargins = self.chartView.bounds.inset(by: graphInsets)
        
        let graphInsets2 = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 30.0, right: 60.0)
        let frameWithMargins2 = self.chartView.bounds.inset(by: graphInsets2)
        
        var delay = 0.0
        for i in 0..<12 {
            let list = lists[i]
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let points = self.getPoints(rect: frameWithMargins, list: list)
                self.lineLayer?.clean()
                self.lineLayer = LineGraphLayer()
                self.lineLayer.clean()
                self.lineLayer.points = points
                self.chartView.layer.addSublayer(self.lineLayer.layer)
                self.lineLayer.drawLayer(rect: frameWithMargins)
                
                self.underLayer?.clean()
                self.underLayer = UnderGraphLayer()
                self.underLayer?.clean()
                self.underLayer.points = points
                self.chartView.layer.addSublayer(self.underLayer.layer)
                self.underLayer.drawLayer(rect: frameWithMargins2)
            }
            delay += 0.025
        }
        
        
    }

    override func viewDidLayoutSubviews() {
        self.reDrawGraphic()
    }
    
    private func getPoints(rect: CGRect, list: [(CGFloat, CGFloat)]) -> [CGPoint] {
        let dataToPoints = DataToPoints(xMin: 1.0, xMax: 31.0, yMin: 0.0, yMax: 120.0)
        
        return dataToPoints.calculatePositions(list: list, rect: rect)
    }
    
    private func animate(_ layer: CAShapeLayer) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.7
        layer.add(animation, forKey: "strokeEndAnimation")
    }

    static let lists = [firstList, secondList]
    
    static let firstList:[(CGFloat,CGFloat)] = [
        (1.0,0.0),
        (2.0,12.0),
        (3.0,24.0),
        (6.0,34.0),
        (9.0,44.0),
        (13.0,48.0),
        (17.0,49.0),
        (20, 50.5),
        (23.0,54.0),
        (27.0,74.0),
        (30.0, 81.0),
        (31.0,120.0)
    ]
    
    static let secondList:[(CGFloat,CGFloat)] = [
        (1.0,50.0),
        (2.0,12.0),
        (3.0,44.0),
        (6.0,34.0),
        (9.0,74.0),
        (13.0,48.0),
        (17.0,49.0),
        (20, 80.5),
        (23.0,94.0),
        (27.0,54.0),
        (30.0, 81.0),
        (31.0,120.0)
    ]
}

