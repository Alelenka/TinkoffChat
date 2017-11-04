//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

struct MessageCellDisplayModel {
    var text: String
    var inbox: Bool
}

protocol IConversationModel: class {
    weak var delegate: IConversationModelDelegate? { get set }
    var userName: String { get set }
    func sendMessage(string text: String)
    func markAsRead()
    func checkIfConversationExist()
}

protocol IConversationModelDelegate: class {
    func userWentOffline()
    func setup(dataSource: [MessageCellDisplayModel])
}

class ConversationModel: IConversationModel, ICommunicationServiceConversationDelegate, ConversationServiceDelegate {
    
    weak var delegate: IConversationModelDelegate?
    private var communicationService: ICommunicationService
    private var conversationService: IConversationService
    private var userID: String
    private var messages: [MessageCellDisplayModel] = []
    
    var userName: String
    
    init(communicationService: ICommunicationService, conversationService: IConversationService, userID: String) {
        self.communicationService = communicationService
        self.conversationService = conversationService
        
        self.userID = userID
        self.userName = self.conversationService.getUserName(withID: self.userID)
        
        for message in self.conversationService.getUserConversation(withID: self.userID) {
            let newMessage = MessageCellDisplayModel(text: message.text, inbox: message.incoming)
            self.messages.append(newMessage)
        }
        
    }
    
    var messageHistory = [MessageCellDisplayModel]() {
        didSet {
            delegate?.setup(dataSource: messageHistory)
        }
    }
    
    func sendMessage(string text: String) {
        
        conversationService.sendMessage(string: text, to: userID) { (success: Bool, error: Error?) in
            if let error = error {
                print("Error sending message: \(error)")
            } else if success {
                print("send success")
            } else {
                print("Error sending message: unknown error")
            }
        }
    }
    
    func markAsRead() {
        communicationService.markConversationAsRead(withuserID: userID)
    }
    
    func checkIfConversationExist() {
        if messages.count > 0 {
            messageHistory = messages
        }
    }
    
    // MARK: - CommunicationServiceDelegate
    func didLostUser(withID userID: String) {
        if userID == self.userID {
            delegate?.userWentOffline()
        }
    }
    
    func didReceive(message: Message) {
        let newMessage = MessageCellDisplayModel(text: message.text, inbox: message.incoming)
        messages.append(newMessage)
        messageHistory = messages
    }
    
    func updateMessages(message: Message) {
        let newMessage = MessageCellDisplayModel(text: message.text, inbox: message.incoming)
        messages.append(newMessage)
        messageHistory = messages
    }
}
