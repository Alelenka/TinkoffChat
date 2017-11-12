//
//  AppUserExtensions.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 04.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import CoreData

extension AppUser {
    
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context")
            return nil
        }
        var appUser: AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(withModel: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found!")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser: \(error.localizedDescription)")
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        
        return appUser
    }
    
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        if let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser {
            if appUser.currentUser == nil {
                let currentUser = User.findOrInsertUser(with: User.generatedUserIdString, in: context)
                currentUser?.name = "a.belyaeva"
                appUser.currentUser = currentUser
            }
            return appUser
        }
        
        return nil
    }
    
    static func fetchRequestAppUser(withModel model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            print("No template with name: \(templateName)")
            return nil
        }
        
        return fetchRequest
    }
    
    
}
