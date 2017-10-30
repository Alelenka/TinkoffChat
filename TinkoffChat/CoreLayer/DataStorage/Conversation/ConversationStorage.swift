//
//  ConversationStorage.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol ConversationStorageDelegate: class {
    func conversationChanged(conversation: ConversationElement)
    func newConversationCreated(conversation: ConversationElement)
}

protocol ConversationMessageStorageDelegate: class {
    func updateConversation(conversation: [Message])
}

protocol IConversationStorageData {
    func getConversationList() -> [ConversationElement]
    func getConversation(forUser userId: String) -> [Message]
}

protocol IConversationStorage {
    func saveNewConversation(withUser userID: String, userName: String?)
    func removeConversation(witUser userId: String)
    func saveNewMessage(messageText: String, userId: String)
    func markMessageAsRead(withUserID userID: String)
}

class ConversationStorage: IConversationStorageData, IConversationStorage {
    private var converationList: [ConversationElement] = []
    private let myID = UUID().uuidString
    
    weak var delegate: ConversationStorageDelegate?
    weak var conversation: ConversationMessageStorageDelegate?
    
    // MARK: - Data
    func getConversationList() -> [ConversationElement] {
        return converationList
    }
    
    func getConversation(forUser userId: String) -> [Message] {
        if let ind = converationList.index(where: {$0.userId == userId }) {
            return converationList[ind].messages
        } else {
            print("Error findning user conversation")
            return []
        }
    }
    
    // MARK: - Storage
    func saveNewMessage(messageText: String, userId: String)  {
        let newMessage = Message.init(withText: messageText, user: userId)!
        newMessage.incoming = !(userId == myID)
        if let ind = converationList.index(where: {$0.userId == userId}) {
            converationList[ind].addMessage(message: newMessage)
            delegate?.conversationChanged(conversation: converationList[ind])
            conversation?.updateConversation(conversation: converationList[ind].messages)
        }
    }
    
    func saveNewConversation(withUser userID: String, userName: String?) {
        
        if let newConversation = ConversationElement.init(withUser: userID, userName: userName) {
            if converationList.index(where: {$0.userId == userID}) == nil {
                converationList.append(newConversation)
                delegate?.newConversationCreated(conversation: newConversation)
            }
        }
    }
    
    func removeConversation(witUser userId: String) {
        if let ind = converationList.index(where: {$0.userId == userId}){
            converationList.remove(at: ind)
        }
    }
    
    func markMessageAsRead(withUserID userID: String) {
        if let ind = converationList.index(where: {$0.userId == userID}) {
            converationList[ind].hasUnreadMessages = false
            delegate?.conversationChanged(conversation: converationList[ind])
        }
    }
}
