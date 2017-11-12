//
//  FetchedRequestsManager.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 12.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import CoreData

import CoreData

struct FetchedRequestsManager {
    let objectModel: NSManagedObjectModel?
    
    init(objectModel: NSManagedObjectModel?) {
        self.objectModel = objectModel
    }
    
    func fetchRequestAllConversations() -> NSFetchRequest<Conversation>? {
        let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
        return fetchRequest
    }
    
    func fetchRequestAllOnlineConversations() -> NSFetchRequest<Conversation>? {
        let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
        fetchRequest.predicate = NSPredicate(format: "user.isOnline == %@", NSNumber(value: true))
        return fetchRequest
    }
    
    func fetchRequestConversationWithID(id: String) -> NSFetchRequest<Conversation>? {
        if let model = objectModel {
            return Conversation.fetchRequestConversationWithID(id: id, withModel: model)
        } else {
            print("Error at model in context")
            return nil
        }
    }
    
    func fetchRequestUserWithID(id: String) -> NSFetchRequest<User>? {
        if let model = objectModel {
            return User.fetchRequestUserWithID(id: id, withModel: model)
        } else {
            print("Error at model in context")
            return nil
        }
    }
    
    func fetchRequestMessagesWithConversationID(id: String) -> NSFetchRequest<Message>? {
        if let model = objectModel {
            return Message.fetchRequestMessagesWithConversationID(id: id, withModel: model)
        } else {
            print("Error at model in context")
            return nil
        }
    }
    
}
