//
//  ConversationService.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol IConversationService: class {
    var communicator: ICommunicator { get set }
    weak var delegate: ConversationServiceDelegate? { set get }
    func getUserName(withID userID: String) -> String
    func getUserConversation(withID userID: String) -> [Message]
    func sendMessage(string text: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
}

protocol ConversationServiceDelegate: class {
    func updateMessages(message: Message)
}

class ConversationService: IConversationService, ConversationMessageStorageDelegate {
    
    var communicator: ICommunicator
    var dataStorage: ConversationStorage // TO_DO
    weak var delegate: ConversationServiceDelegate?
    
    init(communicator: ICommunicator, storage: ConversationStorage) {
        self.communicator = communicator
        self.dataStorage = storage
        self.dataStorage.conversation = self
    }
    
    func getUserName(withID userID: String) -> String {
        return dataStorage.getUserName(withId: userID)
    }
    
    func getUserConversation(withID userID: String) -> [Message] {
        return dataStorage.getConversation(forUser: userID)
    }
    
    func sendMessage(string text: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        dataStorage.saveMessageFromMe(to: userID, text: text)
        communicator.sendMessage(string: text, to: userID, completionHandler: completionHandler)
    }
    
    func updateConversation(withMessage message: Message) {
        delegate?.updateMessages(message: message)
    }
}
