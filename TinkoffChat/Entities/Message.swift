//
//  Message.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 22.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class Message  {
    var author : String?
    var message : String?
    var messageID: String?
    var date: Date?
    
    init?(json: [String: Any], userId: String) {
        
        self.author = userId
        self.date = Date()
        self.messageID = json["messageId"] as? String
        self.message = json["text"] as? String
    }
}
