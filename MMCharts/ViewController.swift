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
    private var gridLayer: GraphGridLayer!
    private var axisLayer: AxisGraphLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(chartView)
        
        self.view.backgroundColor = UIColor(rgb: 0x614AD9)
        
        chartView.translatesAutoresizingMaskIntoConstraints = false
        
        chartView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        chartView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        chartView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        chartView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
        
//        chartView.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
    }
    
    @objc private func tapped(_: UITapGestureRecognizer) {
        self.reDrawGraphic()
    }
    
    var index: Int = 0
    
    
    static let gridColor = UIColor.white.withAlphaComponent(0.1)
    static let curveColor = UIColor(rgb: 0x8EFFEC)
    let graphInsets = UIEdgeInsets(top: 20.0, left: 40.0, bottom: 20.0, right: 40.0)
    static let lineDashPattern: [NSNumber]? = [4,3]
    
    private func reDrawGraphic() {
        index = index == 0 ? 1 : 0
        
        let extremeValues = GraphHelper.getExtremeValues(values: ViewController.firstList)
        let lists = MultiplierForAnimation().multiply(from: ViewController.lists[index], to: ViewController.lists[index == 0 ? 1 : 0], times: 10)
        
        let frameWithMargins = self.chartView.bounds.inset(by: graphInsets)
        
        let gradientLayer = GraphUnderGradientLayer(underWeightBgColor: ViewController.curveColor)
        let lineLayer = GraphCurvesLayer(color: ViewController.curveColor)

        self.addAxisLayer()
        self.addGridLayer()
        self.addLabels(frameWithMargins, extremeValues: extremeValues)
        
        self.chartView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.chartView.layer.addSublayer(self.gridLayer.layer)
        self.chartView.layer.addSublayer(self.axisLayer.layer)
        self.chartView.layer.addSublayer(self.labels.layer)

        var delay = 0.0
        for i in 0..<12 {
            let list = lists[i]
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.chartView.layer.sublayers?.forEach { if $0.name == GraphUnderGradientLayer.identifier || $0.name == GraphCurvesLayer.identifier {
                    $0.removeFromSuperlayer()
                    }}

                let points = GraphHelper.getPoints(rect: frameWithMargins, list: list, extremeValues: extremeValues)
                lineLayer.clean()
                lineLayer.points = points
                lineLayer.drawLayer(rect: frameWithMargins)
                
                gradientLayer.clean()
                gradientLayer.points = points
                gradientLayer.drawLayer(rect: frameWithMargins)
                
                self.chartView.layer.addSublayer(lineLayer.layer)
                self.chartView.layer.addSublayer(gradientLayer.layer)

            }
            delay += 0.02
        }

    }
    
    private func addGridLayer() {
        self.gridLayer?.clean()
        
        self.gridLayer = GraphGridLayer(margins: graphInsets,
                                   gridColor: ViewController.gridColor,
                                   withVerticalLines: false,
                                   lineDashPattern: ViewController.lineDashPattern)
        self.gridLayer.drawLayer(rect: self.chartView.bounds)
    }
    
    
    private func addAxisLayer() {
        self.axisLayer?.clean()
        self.axisLayer = AxisGraphLayer(margins: graphInsets,
                                        axisColor: ViewController.gridColor,
                                        withVerticalAxis: false,
                                        lineDashPattern: ViewController.lineDashPattern)
        self.axisLayer.drawLayer(rect: self.chartView.bounds)
    }
    
    private var labels: GraphLabelsLayer!
    private func addLabels(_ rect: CGRect, extremeValues: GraphHelperExtremeValues) {
        let model = GraphLabelsLayerModel(values: ViewController.firstList, rect: rect, extremeValues: extremeValues)
        
        self.labels?.clean()
        self.labels = GraphLabelsLayer(margins: self.graphInsets, model: model)
        self.labels?.drawLayer(rect: self.chartView.bounds)
    }

    override func viewDidLayoutSubviews() {
        self.reDrawGraphic()
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

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

