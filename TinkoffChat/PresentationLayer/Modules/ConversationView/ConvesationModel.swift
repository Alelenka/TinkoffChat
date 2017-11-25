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
    var conversationService: IConversationService { get set }
    weak var delegate: IConversationModelDelegate? { get set }
    var userName: String { get set }
    func getRowsIn(section: Int) -> Int
    func getConversation(at indexPath: IndexPath) -> MessageCellDisplayModel
    func sendMessage(string text: String)
    func markAsRead()
}

protocol IConversationModelDelegate: class {
    func userStateChanged(online: Bool)
}

class ConversationModel: IConversationModel, ICommunicationServiceConversationDelegate, ConversationServiceDelegate {
    
    weak var delegate: IConversationModelDelegate?
    private var communicationService: ICommunicationService
    var conversationService: IConversationService
    private var conversationID: String
    private var messages: [MessageCellDisplayModel] = []
    
    var userName: String
    
    init(communicationService: ICommunicationService, conversationService: IConversationService, conversationID: String) {
        self.communicationService = communicationService
        self.conversationService = conversationService
        
        self.conversationID = conversationID
        self.userName = self.conversationService.getUserName(withID: self.conversationID)
        
        for message in self.conversationService.getUserConversation(withID: self.conversationID) {
            let newMessage = MessageCellDisplayModel(text: message.text, inbox: message.incoming)
            self.messages.append(newMessage)
        }
        
    }
    
    func sendMessage(string text: String) {
        
        conversationService.sendMessage(string: text, to: conversationID) { (success: Bool, error: Error?) in
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
        communicationService.markConversationAsRead(withuserID: conversationID)
    }
    
    // MARK: - FRC
    
    func getRowsIn(section: Int) -> Int {
        guard let frc = conversationService.fetchedResuts.frc,
            let sections = frc.sections else {
                return 0
        }

        return sections[section].numberOfObjects
    }
    
    func getConversation(at indexPath: IndexPath) -> MessageCellDisplayModel {
        
        
        if let message = conversationService.fetchedResuts.frc?.object(at: indexPath) {
            
            let messageDisplayModel = MessageCellDisplayModel(
                text: message.text ?? "something wrong",
                inbox: message.author?.appUser == nil)
            
            return messageDisplayModel
        }
        
        return MessageCellDisplayModel(text: "", inbox: false)
    }
    
    // MARK: - CommunicationServiceDelegate
    
    func didLostUser(withID userID: String) {
        delegate?.userStateChanged(online: false)
    }
    
    func didFoundUser(withID userID: String) {
        delegate?.userStateChanged(online: true)
    }
    
    func didReceive(message: MessageElement) {

    }
    
    func updateMessages(message: MessageElement) {

    }
}
