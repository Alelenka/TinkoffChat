//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class RootAssembly {
    
    private static let coreDataStack: CoreDataStack = {
        return CoreDataStack()
    }()
    
    static let conversationStorage: ConversationStorage = {
        return ConversationStorage(with: coreDataStack)
    }()
    
    static let conversationListModule: ConversationsListAssembly = {
        return ConversationsListAssembly(with: conversationStorage)
        
    }()
    
    static let conversationModule: ConversationAssembly = {
        return ConversationAssembly(with: conversationStorage)
    }()
    
    static let profileModule = ProfileAssembly(with: coreDataStack)

}
