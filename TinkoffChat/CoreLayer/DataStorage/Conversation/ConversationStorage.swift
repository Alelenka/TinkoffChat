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

protocol IConversationStorageInfo {
    func getCurrentUserName() -> String
    func getCurrentUserId() -> String
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

class ConversationStorage: IConversationStorage, IConversationStorageData, IConversationStorageInfo {
    
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
                return User.generatedUserIdString
        }
        return currentUserID
    }
    
    // MARK: - Data
    
    func getCurrentUserName() -> String {
        guard let appUser = AppUser.findOrInsertAppUser(in: stack.context),
            let currentUserName = appUser.currentUser?.name else {
                assertionFailure()
                return "a.belyaeva"
        }
        return currentUserName
    }
    
    func getCurrentUserId() -> String {
        return myID()
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
        
        stack.context.perform {
            conversation.hasUnreadMessage = fromUser != currentUserID
            
            message.text = messageText
            message.author = sender
            
            message.conversation = conversation
            message.lastInConversation = conversation
            
            self.stack.save(context: self.stack.context, completionHandler: { success in
                guard success else {
                    assertionFailure()
                    return
                }
                completionHandler()
            })
        }
        
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
        
        stack.context.perform {
            user.isOnline = true
            conversation.isOnline = true
            if let name = userName {
                user.name = name
            }
            
            if let userConversation = user.conversation {
                userConversation.isOnline = true
            } else {
                user.conversation = conversation
            }
            
            self.stack.save(context: self.stack.context, completionHandler: { success in
                guard success else {
                    assertionFailure()
                    return
                }
            })
        }
    }
    
    func removeConversation(witUser userID: String) {
        guard let user = User.findOrInsertUser(with: userID, in: stack.context) else {
            assertionFailure("Can't find user with given id")
            return
        }
        stack.context.perform {
            user.isOnline = false
            if let conversation = user.conversation {
                conversation.isOnline = false
            }
            
            self.stack.save(context: self.stack.context, completionHandler: { success in
                guard success else {
                    assertionFailure()
                    return
                }
            })
        }
    }
    
    func markMessageAsRead(conversationID: String) {
        guard let conversation = Conversation.findOrInsertConversation(withID: conversationID, in: stack.context) else {
            assertionFailure("Can't find user with given id")
            return
        }
        stack.context.perform {
            conversation.hasUnreadMessage = false
            
            self.stack.save(context: self.stack.context, completionHandler: { success in
                guard success else {
                    assertionFailure()
                    return
                }
            })
        }
    }
    
    func setAllUsersOffline(completionHandler: @escaping () -> () ) {
        let context = stack.context
        
        guard let appUser = AppUser.findOrInsertAppUser(in: context),
            let appUserID = appUser.currentUser?.userID else {
                completionHandler()
                return
        }
        context.perform {
        
            if let allUsers = User.allUsers(inContext: context) {
                for user in allUsers {
                    guard user.userID != appUserID else { continue }
                    user.isOnline = false
                    if let conversation = user.conversation {
                        conversation.isOnline = false
                    }
                }
            }
            
            self.stack.save(context: context, completionHandler: { success in
                guard success else {
                    assertionFailure()
                    return
                }
                completionHandler()
            })
        }
        
    }
}
