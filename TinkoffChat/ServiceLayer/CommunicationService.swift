//
//  CommunicationService.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol ICommunicationService: class {
    weak var delegate: ICommunicationServiceDelegate? { get set }
    weak var conversation: ICommunicationServiceConvesationDelegate? { get set }
    var communicator: ICommunicator { get set }
    func markConversationAsRead(withUserID userID: String)
}

protocol ICommunicationServiceDelegate: class {
//    func userListChanged(list: [ConversationElement])
    func conversationCreated(conversation: ConversationElement)
    func conversationChanged(conversation: ConversationElement)
    func didLostUser(withID userID: String)
}

protocol ICommunicationServiceConvesationDelegate: class {
    func didLostUser(withID userID: String)
    func didReceiveMessage(text: String, fromUser userID: String)
}

extension ICommunicationServiceDelegate {
//    func userListChanged(list: [ConversationElement]) {       }
}

//MARK: -
class CommunicationService: ICommunicationService, ICommunicatorDelegate, ConversationStorageDelegate {
    
    weak var delegate: ICommunicationServiceDelegate?
    weak var conversation: ICommunicationServiceConvesationDelegate?
    var communicator: ICommunicator
    let dataStorage: ConversationStorage // TO_DO
    
    init(communicator: ICommunicator, conversationStorage: ConversationStorage) {
        self.communicator = communicator
        self.dataStorage = conversationStorage
        self.dataStorage.delegate = self
    }
    
    func markConversationAsRead(withUserID userID: String) {
        dataStorage.markMessageAsRead(withUserID: userID)
    }
    
    // MARK: - ICommunicatorDelegate
    
    func didLostUser(userID: String) {
        dataStorage.removeConversation(witUser: userID)
        delegate?.didLostUser(withID: userID)
        conversation?.didLostUser(withID: userID)
    }
    
    func didFoundUser(userID: String, userName: String?) {
        dataStorage.saveNewConversation(withUser: userID, userName: userName)
    }
    
    func didReceiveMessage(text: String, fromUser sender: String, toUser: String) {
        dataStorage.saveNewMessage(messageText: text, userId: sender)
//        conversation?.didReceiveMessage(text: text, fromUser: sender) // TO_DO
    }
    
    // MARK: - StorageDelegate
    
    func conversationChanged(conversation: ConversationElement) {
        delegate?.conversationChanged(conversation: conversation)
    }
    
    func newConversationCreated(conversation: ConversationElement) {
        delegate?.conversationCreated(conversation: conversation)
    }
    
    // MARK: - // TO_DO later
    
    func failedToStartBrowsingForUsers(error: Error) {
    }
    
    func failedToStartAdvertising(error: Error) {
    }
}
