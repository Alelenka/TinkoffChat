//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

struct ConversationsListCellDisplayModel {
    var userID: String
    var name: String
    var message: String?
    var date: Date?
    var online: Bool = false
    var hasUnreadMessages: Bool = false
}

protocol IConversationsListModel: class {
    var communicationService: ICommunicationService { get set }
    weak var delegate: IConversationsListModelDelegate? { get set }
}

protocol IConversationsListModelDelegate: class {
    func setup(dataSource: [ConversationsListCellDisplayModel])
}

class ConversationsListModel: IConversationsListModel, ICommunicationServiceDelegate {
    
    weak var delegate: IConversationsListModelDelegate?
    var communicationService: ICommunicationService
    
    init(communicationService: ICommunicationService) {
        self.communicationService = communicationService
    }
    
    var _conversations = [ConversationsListCellDisplayModel]() {
        didSet {
            conversations = _conversations.sorted {
                                if let date0 = $0.date,
                                    let date1 = $1.date{
                                    return date0 > date1
                                } else {
                                    return $0.name < $1.name
                                }
                            }
        }
    }
    
    var conversations = [ConversationsListCellDisplayModel]() {
        didSet {
            delegate?.setup(dataSource: conversations)
        }
    }
    
    // MARK: - CommunicationServiceDelegate
    
    func conversationCreated(conversation: ConversationElement) {
        let conversationsListCellDisplayModel = ConversationsListCellDisplayModel(
            userID: conversation.userID,
            name: conversation.name,
            message: conversation.lastMessage,
            date: conversation.lastMessageDate,
            online: true,
            hasUnreadMessages: conversation.hasUnreadMessages)
        _conversations.append(conversationsListCellDisplayModel)
    }
    
    func conversationChanged(conversation: ConversationElement) {
        if let conversationIdx = conversationIndex(forUser: conversation.userID) {
            var conversationItem = _conversations[conversationIdx]
            conversationItem.hasUnreadMessages = conversation.hasUnreadMessages
            conversationItem.date = conversation.lastMessageDate
            conversationItem.message = conversation.lastMessage
            
            _conversations[conversationIdx] = conversationItem
        }
    }
    
    func didLostUser(withID userID: String) {
        if let conversationIdx = conversationIndex(forUser: userID) {
            _conversations.remove(at: conversationIdx)
        }
    }


    private func conversationIndex(forUser userID: String) -> Int? {
        if let ind = conversations.index(where: {$0.userID == userID }) {
            return ind
        } else {
            return nil
        }
    }
    
}
