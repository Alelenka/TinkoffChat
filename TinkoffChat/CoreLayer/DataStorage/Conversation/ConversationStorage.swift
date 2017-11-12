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
    func updateConversation(withMessage message: MessageElement)
}

protocol IConversationStorageData {
    func getUserName(withId userID: String) -> String
    func saveMessageFromMe(to userID: String, text: String)
}

protocol IConversationStorage {
    weak var delegate: ConversationStorageDelegate?  { get set }
    weak var conversation: ConversationMessageStorageDelegate?  { get set }
    
    func saveNewConversation(withUser userID: String, userName: String?)
    func removeConversation(witUser userID: String)
    func markMessageAsRead(conversationID: String)
    func saveNewMessage(messageText: String, userID: String)
    func setAllUsersOffline(completionHandler: @escaping () -> () )
}

extension IConversationStorage {
    func saveNewConversation(withUser userID: String, userName: String?) {  }
    func removeConversation(witUser userID: String) {   }
}

class ConversationStorage: IConversationStorage, IConversationStorageData {
    
    weak var delegate: ConversationStorageDelegate?
    weak var conversation: ConversationMessageStorageDelegate?
    
    private var converationList: [ConversationElement] = []
    var stack: ICoreDataStack //>????
    
    init(with coreData: ICoreDataStack){
        self.stack = coreData
    }
    
    private func myID() -> String {
        guard let appUser = AppUser.findOrInsertAppUser(in: stack.context),
            let currentUserID = appUser.currentUser?.userID else {
                assertionFailure()
                return UUID().uuidString
        }
        return currentUserID
    }
    
    // MARK: - Data
    func getConversationList() -> [ConversationElement] {
        return converationList
    }
    
    func getUserName(withId userID: String) -> String {
        guard let user = User.findOrInsertUser(with: userID, in: stack.context) else {
            assertionFailure("Can't find user with given id")
            return "noname"
        }
        
        return user.name ?? "noname"
    }
    
    func getConversation(forUser userID: String) -> [MessageElement] {
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
        saveMessage(messageText: messageText, fromUser: userID, toUser: myID(), completionHandler: {})
    }
    
    func saveMessageFromMe(to userID: String, text: String) {
        saveMessage(messageText: text, fromUser: myID(), toUser: userID, completionHandler: {})
    }
    
    private func saveMessage(messageText: String, fromUser: String, toUser: String, completionHandler: @escaping () -> () ) {

        let currentUserID = myID()
        
        let participantID = currentUserID == fromUser ? toUser : fromUser
        
        let messageID = fromUser + toUser + "\(Date.timeIntervalSinceReferenceDate)"
        guard let sender = User.findOrInsertUser(with: fromUser, in: stack.context),
            let message = Message.insertMessage(withID: messageID, inContext: stack.context),
            let conversation = Conversation.findOrInsertConversation(withID: participantID, in: stack.context) else {
                assertionFailure()
                return
        }
        
        conversation.hasUnreadMessage = fromUser != currentUserID
        
        message.text = messageText
        message.author = sender
        
        message.conversation = conversation
        message.lastInConversation = conversation        
        
        stack.save(context: stack.context, completionHandler: { success in
            guard success else {
                assertionFailure()
                return
            }
            completionHandler()
        })
    }
    
    private func save(message: MessageElement, userID: String) {
        if let ind = converationList.index(where: {$0.userID == userID}) {
            converationList[ind].addMessage(message: message)
            
            delegate?.conversationChanged(conversation: converationList[ind])
            conversation?.updateConversation(withMessage: message)
        } else {
            print("get unknown message!!!!!!")
        }
    }
    
    func saveNewConversation(withUser userID: String, userName: String?) {
        guard let user = User.findOrInsertUser(with: userID, in: stack.context),
        let conversation = Conversation.findOrInsertConversation(withID: userID, in: stack.context) else {
                assertionFailure("Can't find user with given id")
                return
        }
        
        user.isOnline = true
        if let name = userName {
            user.name = name
        }
        
        if user.conversation == nil {
            user.conversation = conversation
        }
        
        stack.save(context: stack.context, completionHandler: { success in
            guard success else {
                assertionFailure()
                return
            }
        })
    }
    
    func removeConversation(witUser userID: String) {
        guard let user = User.findOrInsertUser(with: userID, in: stack.context),
            let conversation = Conversation.findOrInsertConversation(withID: userID, in: stack.context) else {
            assertionFailure("Can't find user with given id")
            return
        }
        
        user.isOnline = false
        conversation.user = user
        
        stack.save(context: stack.context, completionHandler: { success in
            guard success else {
                assertionFailure()
                return
            }
        })
    }
    
    func markMessageAsRead(conversationID: String) {
        guard let conversation = Conversation.findOrInsertConversation(withID: conversationID, in: stack.context) else {
            assertionFailure("Can't find user with given id")
            return
        }
        
        conversation.hasUnreadMessage = false
        
        stack.save(context: stack.context, completionHandler: { success in
            guard success else {
                assertionFailure()
                return
            }
        })
    }
    
    func setAllUsersOffline(completionHandler: @escaping () -> () ) {
        let context = stack.context
        
        guard let appUser = AppUser.findOrInsertAppUser(in: context),
            let appUserID = appUser.currentUser?.userID else {
                completionHandler()
                return
        }
        
        if let allUsers = User.allUsers(inContext: context) {
            for user in allUsers {
                guard user.userID != appUserID else { continue }
                user.isOnline = false
            }
        }
        
        stack.save(context: context, completionHandler: { success in
            guard success else {
                assertionFailure()
                return
            }
            completionHandler()
        })
        
    }
}
