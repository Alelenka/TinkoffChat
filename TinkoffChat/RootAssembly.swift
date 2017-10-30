//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class RootAssembly {
    var conversationStorage = ConversationStorage()
    var conversationListModule: ConversationsListAssembly = ConversationsListAssembly()
    var conversationModel: ConversationAssembly = ConversationAssembly()
}
