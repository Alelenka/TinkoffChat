//
//  ConversationResults.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 12.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol IConversationResults {
    var tableView: UITableView? { get set }
    var frc: NSFetchedResultsController<Message>? { get set }
}

class ConversationResults: NSObject, IConversationResults {
    var frc: NSFetchedResultsController<Message>?
    let stack: ICoreDataStack
    var tableView: UITableView? {
        didSet {
            do {
                try self.frc?.performFetch()
                self.tableView?.reloadData()
            } catch {
                print("Error fetching: \(error)")
            }
        }
    }
    
    init(stack: ICoreDataStack, conversationID: String) {
        self.stack = stack
        
        let context = stack.mainContext
        var persistentStore = context.persistentStoreCoordinator
        if let parent = context.parent {
            persistentStore = parent.persistentStoreCoordinator
        }
        let fetchRequestsManager = FetchedRequestsManager(objectModel: persistentStore?.managedObjectModel)
        
        guard let fetchRequest = fetchRequestsManager.fetchRequestMessagesWithConversationID(id: conversationID) else {
            frc = nil
            super.init()
            return
        }
        super.init()
        
        let dateDescriptor = NSSortDescriptor(key: #keyPath(Message.date), ascending: true)
        fetchRequest.sortDescriptors = [dateDescriptor]
        frc = NSFetchedResultsController<Message>(fetchRequest: fetchRequest,
                                                       managedObjectContext: context,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        frc?.delegate = self
    }
}

extension ConversationResults: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView?.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                tableView?.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView?.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .delete:
            tableView?.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .insert:
            tableView?.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .move, .update : break
        }
    }
}
