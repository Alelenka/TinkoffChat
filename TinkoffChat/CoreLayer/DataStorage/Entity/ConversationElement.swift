//
//  ConversationElement.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 08.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class ConversationElement  {
    var name : String = ""
    var userID: String = ""
    var lastMessageDate: Date?
    var online : Bool = true
    var hasUnreadMessages : Bool = false
    var lastMessage: String? {
        get {
            return messages.last?.text
        }
    }
    
    var messages: [Message] = []
    
    init?(withUser userID: String, userName: String?){
        self.userID = userID
        if let name = userName {
            self.name = name
        } else {
            self.name = "noname"
        }
    }
    
    func addMessage(message: Message){
        hasUnreadMessages = message.incoming
        lastMessageDate = message.date
//        lastMessage = message.text
        
        messages.append(message)
    }
    
    
}

