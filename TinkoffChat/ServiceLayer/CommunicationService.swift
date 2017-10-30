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
    weak var conversation: ICommunicationServiceConversationDelegate? { get set }
    var communicator: ICommunicator { get set }
    func markConversationAsRead(withuserID userID: String)
}

protocol ICommunicationServiceDelegate: class {
    func conversationCreated(conversation: ConversationElement)
    func conversationChanged(conversation: ConversationElement)
    func didLostUser(withID userID: String)
}

protocol ICommunicationServiceConversationDelegate: class {
    func didLostUser(withID userID: String)
    func didReceive(message: Message)
}

extension ICommunicationServiceDelegate {
//    func userListChanged(list: [ConversationElement]) {       }
}

//MARK: -
class CommunicationService: ICommunicationService, ICommunicatorDelegate, ConversationStorageDelegate {
    
    weak var delegate: ICommunicationServiceDelegate?
    weak var conversation: ICommunicationServiceConversationDelegate?
    var communicator: ICommunicator
    var dataStorage: ConversationStorage
    
    init(communicator: ICommunicator, conversationStorage: ConversationStorage) {
        self.communicator = communicator
        self.dataStorage = conversationStorage
        self.dataStorage.delegate = self
    }
    
    func markConversationAsRead(withuserID userID: String) {
        dataStorage.markMessageAsRead(withuserID: userID)
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
        dataStorage.saveNewMessage(messageText: text, userID: sender)
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
