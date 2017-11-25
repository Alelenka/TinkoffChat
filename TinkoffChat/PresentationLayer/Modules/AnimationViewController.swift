//
//  AnimationCreator.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 25.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

class AnimationViewController: UIViewController {
    
    private var timer: Timer?
    private var longPressGesture = UILongPressGestureRecognizer()
    private var startPoint = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHundler(gestureReconizer:)))
        longPressGesture.minimumPressDuration = 0.15
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    
    @objc private func longPressGestureHundler(gestureReconizer: UILongPressGestureRecognizer) {
        startPoint = gestureReconizer.location(in: self.view)
        
        if gestureReconizer.state == .began {
            startAnimate()
        } else if gestureReconizer.state == .ended{
            stopAnimate()
        }
    }
    
    private func startAnimate() {
        createBlazon()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(createBlazon), userInfo: nil, repeats: true)
    }
    
    private func stopAnimate() {
        timer?.invalidate()
    }
    
    
    @objc private func createBlazon() {
        let duration = 1.0
        let options = UIViewAnimationOptions.curveLinear
        
        let xPosition : CGFloat = CGFloat( arc4random_uniform(UInt32(UIScreen.main.bounds.width))) + 40.0
        let yPosition : CGFloat = UIScreen.main.bounds.height + 40.0
        
        let blazon = UIImageView()
        blazon.image = #imageLiteral(resourceName: "blazon")
        blazon.frame = CGRect(x: startPoint.x - 20.0, y: startPoint.y - 20.0, width: 40.0, height: 40.0)
        self.view.addSubview(blazon)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: {
            blazon.frame = CGRect(x: xPosition, y: yPosition, width: 40.0, height: 40.0)
        }) { (finished) in
            blazon.removeFromSuperview()
        }
    }
}
