//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

protocol IConversationsListModel: class {
    var communicationService: ICommunicationService { get set }
    weak var delegate: IConversationsListModelDelegate? { get set }
}

protocol IConversationsListModelDelegate: class {
    func setup(dataSource: [ConversationElement])
}

class ConversationsListModel: IConversationsListModel, ICommunicationServiceDelegate {
    
    weak var delegate: IConversationsListModelDelegate?
    var communicationService: ICommunicationService
    
    init(communicationService: ICommunicationService) {
        self.communicationService = communicationService
    }
    
    var _conversations = [ConversationElement]() {
        didSet {
            conversations = _conversations.sorted {
                                if let date0 = $0.lastMessageDate,
                                    let date1 = $1.lastMessageDate{
                                    return date0 > date1
                                } else {
                                    return $0.name < $1.name
                                }
                            }
        }
    }
    
    var conversations = [ConversationElement]() {
        didSet {
            delegate?.setup(dataSource: conversations)
        }
    }
    
    // MARK: - CommunicationServiceDelegate
    
    func didFoundUser(name userName: String, withID userID: String) {
        let conversationElement = ConversationElement.init(withUser: userID, userName: userName)!
        _conversations.append(conversationElement)
    }
    
    func didLostUser(withID userID: String) {
        
        if let conversationIdx = conversationIndex(forUser: userID) {
            _conversations.remove(at: conversationIdx)
        }
    }
    
    func didReceiveMessage(text: String, fromUser userID: String) {
        
        if let conversationIdx = conversationIndex(forUser: userID) {
            let conversationItem = _conversations[conversationIdx]
            conversationItem.lastMessage = text
            conversationItem.lastMessageDate = Date()
            conversationItem.hasUnreadMessages = true
            
            /// For now...
            let newMessage = Message.init(withText: text, user: fromUser)!
            newMessage.incoming = true
            converationList[ind].addMessage(message: newMessage)
            
            _conversations[conversationIdx] = conversationItem
        }
    }
    
    func didReadConversation(withUserID userID: String) {
        if let conversationIdx = conversationIndex(forUser: userID) {
            conversations[conversationIdx].hasUnreadMessages = false
            delegate?.setup(dataSource: conversations)
        }
    }

    private func conversationIndex(forUser userID: String) -> Int? {
        if let ind = conversations.index(where: {$0.userId == userID }) {
            return ind
        } else {
            return nil
        }
    }
    
}
