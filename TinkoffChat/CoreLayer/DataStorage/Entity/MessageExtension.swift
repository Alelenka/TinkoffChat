//
//  MessageExtension.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 12.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import CoreData

extension Message {
    
    static func insertMessage(withID id: String, inContext context: NSManagedObjectContext) -> Message? {
        if let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message {
            message.messageID = id
            message.date = Date()
            return message
        }
        return nil
    }
}

extension Message {
    
    static func fetchRequestMessagesWithConversationID(id: String, withModel model: NSManagedObjectModel) -> NSFetchRequest<Message>? {
        let templateName = "MessagesWithConversationID"
        let variables = [
            "conversationID" : id
        ]
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: variables) as? NSFetchRequest<Message> else {
            assertionFailure("No template with name: \(templateName)")
            return nil
        }
        
        return fetchRequest.copy() as? NSFetchRequest<Message>
    }
}
