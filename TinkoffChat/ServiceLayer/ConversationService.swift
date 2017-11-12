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
    var fetchedResuts: ConversationResults {get set}
    func getUserName(withID userID: String) -> String
    func getUserConversation(withID userID: String) -> [MessageElement]
    func sendMessage(string text: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
}

protocol ConversationServiceDelegate: class {
    func updateMessages(message: MessageElement)
}

class ConversationService: IConversationService, ConversationMessageStorageDelegate {
    
    var communicator: ICommunicator
    var dataStorage: ConversationStorage // TO_DO
    weak var delegate: ConversationServiceDelegate?
    var fetchedResuts: ConversationResults
    
    init(communicator: ICommunicator, storage: ConversationStorage, conversationID: String) {
        self.communicator = communicator
        self.dataStorage = storage
        self.fetchedResuts = ConversationResults.init(stack: storage.stack, conversationID: conversationID)
        self.dataStorage.conversation = self
    }
    
    func getUserName(withID userID: String) -> String {
        return dataStorage.getUserName(withId: userID)
    }
    
    
    func getUserConversation(withID userID: String) -> [MessageElement] {
        return dataStorage.getConversation(forUser: userID)
    }
    
    func sendMessage(string text: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        dataStorage.saveMessageFromMe(to: userID, text: text)
        communicator.sendMessage(string: text, to: userID, completionHandler: completionHandler)
    }
    
    func updateConversation(withMessage message: MessageElement) {
        delegate?.updateMessages(message: message)
    }
}
