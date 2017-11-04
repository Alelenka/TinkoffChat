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
    func updateConversation(withMessage message: Message)
}

protocol IConversationStorageData {
//    func getConversationList() -> [ConversationElement]
    func getUserName(withId userID: String) -> String
    func getConversation(forUser userID: String) -> [Message]
    func saveMessageFromMe(to userID: String, text: String)
}

protocol IConversationStorage {
    weak var delegate: ConversationStorageDelegate?  { get set }
    weak var conversation: ConversationMessageStorageDelegate?  { get set }
    
    func saveNewConversation(withUser userID: String, userName: String?)
    func removeConversation(witUser userID: String)
    func saveNewMessage(messageText: String, userID: String)
    func markMessageAsRead(withuserID userID: String)
}

extension IConversationStorage {
    func saveNewConversation(withUser userID: String, userName: String?) {  }
    func removeConversation(witUser userID: String) {   }
}

class ConversationStorage: IConversationStorageData, IConversationStorage {
    
    weak var delegate: ConversationStorageDelegate?
    weak var conversation: ConversationMessageStorageDelegate?
    
    private var converationList: [ConversationElement] = []
    private let myID = UUID().uuidString
    
    // MARK: - Data
    func getConversationList() -> [ConversationElement] {
        return converationList
    }
    
    func getUserName(withId userID: String) -> String {
//        if let ind = converationList.index(where: {$0.userID == userID }) {
//            return converationList[ind].name
//        } else {
//            return "noname"
//        }
        return converationList.first(where: { $0.userID == userID })?.name ?? "noname"
    }
    
    func getConversation(forUser userID: String) -> [Message] {
        if let ind = converationList.index(where: {$0.userID == userID }) {
            return converationList[ind].messages
        } else {
            print("Error findning user conversation")
            return []
        }
//        return converationList.first(where: { $0.userID == userID })?.messages ?? []
    }
    
    // MARK: - Storage
    func saveNewMessage(messageText: String, userID: String)  {
        let newMessage = Message.init(withText: messageText, user: userID)!
        newMessage.incoming = true
        save(message: newMessage, userID: userID)
    }
    
    func saveMessageFromMe(to userID: String, text: String) {
        let newMessage = Message.init(withText: text, user: myID)!
        newMessage.incoming = false
        save(message: newMessage, userID: userID)
    }
    
    private func save(message: Message, userID: String) {
        if let ind = converationList.index(where: {$0.userID == userID}) {
            converationList[ind].addMessage(message: message)
            
            delegate?.conversationChanged(conversation: converationList[ind])
            conversation?.updateConversation(withMessage: message)
        } else {
            print("get unknown message!!!!!!")
        }
    }
    
    func saveNewConversation(withUser userID: String, userName: String?) {
        
        if let newConversation = ConversationElement.init(withUser: userID, userName: userName) {
            if converationList.index(where: {$0.userID == userID}) == nil {
                converationList.append(newConversation)
                delegate?.newConversationCreated(conversation: newConversation)
            }
        }
    }
    
    func removeConversation(witUser userID: String) {
        if let ind = converationList.index(where: {$0.userID == userID}){
            converationList.remove(at: ind)
        }
    }
    
    func markMessageAsRead(withuserID userID: String) {
        if let ind = converationList.index(where: {$0.userID == userID}) {
            converationList[ind].hasUnreadMessages = false
            delegate?.conversationChanged(conversation: converationList[ind])
        }
    }
}
