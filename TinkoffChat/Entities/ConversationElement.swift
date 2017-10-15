//
//  ConversationElement.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 08.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class ConversationElement  {
    var name : String?
    var message : String?
    var date: Date?
    var online : Bool = false
    var hasUnreadMessages : Bool = false
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let message = json["message"] as? String,
            let date = json["date"] as? String,
            let online = json["online"] as? Bool,
            let hasUnreadMessages = json["hasUnreadMessages"] as? Bool else {
                return nil
        }
        
        self.name = name
        self.message = message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd.MM.yyyy"
        self.date = dateFormatter.date(from:date)
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
        
    }
}

