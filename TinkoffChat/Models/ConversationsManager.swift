//
//  ConversationManager.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 22.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol ConversationsManagerDelegate: class {
    func updateConversationsList()
    func updateCurrentConversation()
}

class ConversationsManager: CommunicatorDelegate {
    
    static let shared = ConversationsManager()
    let communicator = MultipeerCommunicator()
    
    weak var listDelegate: ConversationsManagerDelegate?
    weak var conversationDelegate: ConversationsManagerDelegate?
    
    private var currentConversationId: String?
    
    var converationList: [ConversationElement] = []
    var currentConversation: ConversationElement? {
        get {
            if let ind = converationList.index(where: {$0.userId == currentConversationId }) {
                return converationList[ind]
            } else {
                return nil
            }
        }
    }
    
    private init() {
        communicator.delegate = self
    }
    
    func send(_ message: Message) {
        guard let conversation = currentConversation else {
            return
        }
    
        communicator.sendMessage(string: message.text, to: conversation.userId) { (success, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if success {
                if let conversation = self.currentConversation {
                    conversation.addMessage(message: message)
                    self.conversationDelegate?.updateConversationsList()
                    self.conversationDelegate?.updateCurrentConversation()
                }
            }
            else {
                print("Can't send message to peer: \(self.currentConversationId ?? "none")")
            }
        }
    }
    
    func selectCurrentConversation(withId userId: String) {
        currentConversationId = userId
        if let ind = converationList.index(where: {$0.userId == userId }) {
            converationList[ind].hasUnreadMessages = false
        }
        
    }
    
    func forgetCurrentConversation() {
        currentConversationId = nil
    }
    
    // MARK: - CommunicatorDelegate
    
    func didFoundUser(userID: String, userName: String?) {
        
        let newConversation = ConversationElement.init(withUser: userID, userName: userName)!
        converationList.append(newConversation)
        
        converationList = converationList.sorted {
            if let date0 = $0.lastMessageDate,
                let date1 = $1.lastMessageDate{
                return date0 > date1
            } else {
                return $0.name < $1.name
            }
        }
        
        DispatchQueue.main.async {
            self.listDelegate?.updateConversationsList()
            if (userID == self.currentConversationId){
                self.conversationDelegate?.updateCurrentConversation()
            }
        }
    }
    
    func didLostUser(userID: String) {
        
        if let ind = converationList.index(where: {$0.userId == userID }) {
            converationList.remove(at: ind)
        }
        
        DispatchQueue.main.async {
            self.listDelegate?.updateConversationsList()
            if (userID == self.currentConversationId){
                self.currentConversationId = nil
                self.conversationDelegate?.updateCurrentConversation()
            }
        }
        
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        //TODO
    }
    
    func failedToStartAdvertising(error: Error) {
        //TODO
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
        if let ind = converationList.index(where: {$0.userId == fromUser }) {
            let newMessage = Message.init(withText: text, user: fromUser)!
            newMessage.incoming = true
            converationList[ind].addMessage(message: newMessage)
            if fromUser == currentConversationId {
                converationList[ind].hasUnreadMessages = false
            }
        }
        
        DispatchQueue.main.async {
            self.listDelegate?.updateConversationsList()
            if (fromUser == self.currentConversationId){
                self.conversationDelegate?.updateCurrentConversation()
            }
        }
    }
}
