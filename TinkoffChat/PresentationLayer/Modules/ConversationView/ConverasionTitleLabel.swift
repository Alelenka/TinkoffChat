//
//  ConverasionTitleLabel.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 25.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ConverasionTitleLabel: UILabel {
    
    override var text: String? {
        didSet {
            sizeToFit()
        }
    }
    
    func setOnline(_ online : Bool) {
        let scale: CGFloat = online ? 1.1 : 1.0
        let color : UIColor = online ? .green : .black
        
        UIView.animate(withDuration: 1.0) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        
        UIView.transition(with: self, duration: 1.0, options: .transitionCrossDissolve, animations: {
            self.textColor = color
        }, completion: nil)
    }

}
