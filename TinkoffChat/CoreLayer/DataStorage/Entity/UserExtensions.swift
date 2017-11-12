//
//  UserExtensions.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 04.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension User {
    
    static func findOrInsertUser(with id: String, in context: NSManagedObjectContext) -> User? {
        let manager = FetchedRequestsManager(objectModel: context.persistentStoreCoordinator?.managedObjectModel)
        guard let fetchRequest = manager.fetchRequestUserWithID(id: id) else {
            return nil
        }
        
        var user: User?
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple users with same id found!")
            if let foundUser = results.first {
                user = foundUser
            }
        } catch {
            print("Failed to fetch User: \(error.localizedDescription)")
        }
        
        if user == nil {
            user = insertUser(with: id, in: context)
        }
        
        return user
    }
    
    static func insertUser(with id: String, in context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.userID = id
            return user
        }
        
        return nil
    }
    
    static var generatedUserIdString: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static func allUsers(inContext context: NSManagedObjectContext) -> [User]? {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Failed to fetch all Users: \(error.localizedDescription)")
            return nil
        }
    }
}

extension User {
    // MARK : FetchRequest
    static func fetchRequestUserWithID(id: String, withModel model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        
        let templateName = "UserWithID"
        let variables = [
            "userID" : id
        ]
        
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: variables) as? NSFetchRequest<User> else {
            print("No template with name: \(templateName)")
            return nil
        }
        
        return fetchRequest.copy() as? NSFetchRequest<User>
    }
    
    static func fetchRequestUsersOnline(withModel model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        
        let templateName = "UsersOnline"
        
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<User> else {
            print("No template with name: \(templateName)")
            return nil
        }
        
        return fetchRequest.copy() as? NSFetchRequest<User>
    }
}
