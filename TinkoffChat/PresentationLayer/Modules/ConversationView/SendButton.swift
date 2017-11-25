//
//  SendButton.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 25.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class SendButton: UIButton {
    
    private let enabledColor = UIColor.init(red: 0.94, green: 0.769, blue: 0.059, alpha: 1.0)
    private let disabledColor = UIColor.init(red: 0.173, green: 0.243, blue: 0.341, alpha: 1.0)
    
    override func awakeFromNib() {
        layer.cornerRadius = 4.0
        layer.borderWidth = 1.0
        layer.borderColor = disabledColor.cgColor
        isEnabled = false
    }
    
    override var isEnabled: Bool {
        didSet {
            let color : CGColor = isEnabled ? enabledColor.cgColor : disabledColor.cgColor
            layer.borderColor = color
            scale()
        }
    }
    
    

}
