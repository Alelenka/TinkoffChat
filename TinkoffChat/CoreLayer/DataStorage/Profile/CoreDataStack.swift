//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 04.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataStack: class {
    var context: NSManagedObjectContext { get }
    var mainContext: NSManagedObjectContext { get }
    func save(context: NSManagedObjectContext, completionHandler: @escaping (Bool)->())
}

class CoreDataStack: ICoreDataStack {
    
    private let managedObjectModelName = "TinkoffChat"
    private var _managedObjectModel: NSManagedObjectModel?
    private var managedObjectModel: NSManagedObjectModel? {
        
        if let _managedObjectModel = _managedObjectModel {
            return _managedObjectModel
        } else {
            guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd") else {
                print("Error getting model url")
                return nil
            }
            
            guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
                print("Error creating model from url")
                return nil
            }
            
            _managedObjectModel = model
            return model
        }
    }
    
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        
        if let _persistentStoreCoordinator = _persistentStoreCoordinator {
            return _persistentStoreCoordinator
        } else {
            
            guard let model = managedObjectModel else { return nil }
            
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
            let storeURL = URL.getDocumentsDirectory().appendingPathComponent("TinkoffChat.sqlite")
            
            do {
                let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                               NSInferMappingModelAutomaticallyOption: true]
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
            } catch {
                print("Error adding store to coordinator: \(error.localizedDescription)")
                return nil
            }
            
            _persistentStoreCoordinator = coordinator
            return coordinator
        }
    }
    
    private var _masterContext: NSManagedObjectContext?
    private var masterContext: NSManagedObjectContext? {
        
        if let _masterContext = _masterContext {
            return _masterContext
        } else {
            guard let coordinator = persistentStoreCoordinator else { return nil }
            
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            context.undoManager = nil
            
            _masterContext = context
            return context
        }
    }
    
    var _mainContext: NSManagedObjectContext?
    var mainContext: NSManagedObjectContext {
        
        if let _mainContext = _mainContext {
            return _mainContext
        } else {
            
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.parent = masterContext
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            context.undoManager = nil
            
            _mainContext = context
            return context
        }
    }
    
    var _context: NSManagedObjectContext?
    var context: NSManagedObjectContext {
        
        if let _context = _context {
            return _context
        } else {
            
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = mainContext
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            context.undoManager = nil
            
            _context = context
            return context
        }
    }
    
    func save(context: NSManagedObjectContext, completionHandler: @escaping (Bool)->()) {
        
        if context.hasChanges {
            do {
                try context.save()
                if let parent = context.parent {
                    save(context: parent, completionHandler: completionHandler)
                } else {
                    completionHandler(true)
                }
            } catch {
                print(error) //!!!!! TO_DO
                completionHandler(false)
            }
        } else {
            completionHandler(true)
        }
    }
}
