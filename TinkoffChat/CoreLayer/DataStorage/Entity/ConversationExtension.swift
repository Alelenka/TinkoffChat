//
//  ConversationExtension.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 12.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import CoreData

extension Conversation {
    
    static func findOrInsertConversation(withID id: String, in context: NSManagedObjectContext) -> Conversation? {

        let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
        let predicate = NSPredicate(format: "conversationID == %@", id)
        let sortDescriptor = NSSortDescriptor(key: "conversationID", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var conversation: Conversation?
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple conversations with same id found!")
            if let foundConversation = results.first {
                conversation = foundConversation
            }
        } catch {
            print("Failed to fetch Conversation: \(error.localizedDescription)")
        }
        
        if conversation == nil {
            conversation = Conversation.insertConversation(with: id, in: context)
        }
        return conversation
    }
    
    static func insertConversation(with id: String, in context: NSManagedObjectContext) -> Conversation? {
        if let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation {
            conversation.conversationID = id
            conversation.hasUnreadMessage = false
            return conversation
        }
        return nil
    }
    
}

extension Conversation {
    
    static func fetchRequestConversationWithID(id: String, withModel model: NSManagedObjectModel) -> NSFetchRequest<Conversation>? {
        let templateName = "ConversationWithID"
        let variables = [
            "conversationID" : id
        ]
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: variables) as? NSFetchRequest<Conversation> else {
            assertionFailure("No template with name: \(templateName)")
            return nil
        }
        
        return fetchRequest.copy() as? NSFetchRequest<Conversation>
    }
}
