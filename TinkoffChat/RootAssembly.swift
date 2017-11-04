//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class RootAssembly {
    
    private static let conversationStorage: ConversationStorage = {
            return ConversationStorage()
    }()
    
    static let conversationListModule: ConversationsListAssembly = {
        return ConversationsListAssembly(with: conversationStorage)
        
    }()
    
    static let conversationModel: ConversationAssembly = {
        return ConversationAssembly(with: conversationStorage)
    }()
}
