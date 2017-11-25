//
//  File.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 25.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func scale() {
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.duration = 0.5
        scale.fromValue = 1.0
        scale.toValue = 1.15
        scale.autoreverses = true
        scale.repeatCount = 1
        
        layer.add(scale, forKey: "btnScale")
    }

}
