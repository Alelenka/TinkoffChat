//
//  MessageElement.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 22.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class MessageElement {
    var text: String
    var user: String
    var date: Date?
    var incoming: Bool = true
    
    private let messageEvent = "TextMessage"
    
    init?(withText text: String, user: String){
        self.text = text
        self.date = Date()
        self.user = user
    }
}
