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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.view.addSubview(chartView)
        
        //let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 400.0, height: 150.0)
        
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
        
        let multiplier = MultiplierForAnimation()
        let lists = multiplier.multiply(from: ViewController.lists[index], to: ViewController.lists[index == 0 ? 1 : 0])
        
        var delay = 0.0
        for i in 0..<3 {
            let list = lists[i]
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                print(Date().timeIntervalSince1970)
                self.lineLayer?.clean()
                self.lineLayer = LineGraphLayer()
                self.lineLayer.clean()
                self.lineLayer.points = self.getPoints(rect: self.chartView.frame, list: list)
                self.chartView.layer.addSublayer(self.lineLayer.layer)
                self.lineLayer.drawLayer(rect: self.view.bounds)
            }
            delay += 0.3
        }
        
        
    }
    
    private var lineLayer: LineGraphLayer!
    override func viewDidLayoutSubviews() {
        self.reDrawGraphic()
    }
    
    private func getPoints(rect: CGRect, list: [(CGFloat, CGFloat)]) -> [CGPoint] {
        let dataToPoints = DataToPoints(xMin: 1.0, xMax: 31.0, yMin: 0.0, yMax: 120.0, margins: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0))
        
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
        (17.0,49.0)
    ]
}

