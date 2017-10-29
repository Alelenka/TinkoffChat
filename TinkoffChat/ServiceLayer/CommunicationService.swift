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
    weak var conversation: ICommunicationServiceDelegate? { get set }
    var communicator: ICommunicator { get set }
    func markConversationAsRead(withUserID userID: String)
}

protocol ICommunicationServiceDelegate: class {
    func didFoundUser(name userName: String, withID userID: String)
    func didLostUser(withID userID: String)
    func didReceiveMessage(text: String, fromUser userID: String)
    func didReadConversation(withUserID userID: String)
}

extension ICommunicationServiceDelegate {
    func didFoundUser(name userName: String, withID userID: String) {       }
    func didReadConversation(withUserID userID: String) {       }
}

class CommunicationService: ICommunicationService, ICommunicatorDelegate {
    
    weak var delegate: ICommunicationServiceDelegate?
    weak var conversation: ICommunicationServiceDelegate?
    var communicator: ICommunicator
    
    init(communicator: ICommunicator) {
        self.communicator = communicator
    }
    
    func markConversationAsRead(withUserID userID: String) {
        delegate?.didReadConversation(withUserID: userID)
    }
    
    // MARK: - ICommunicatorDelegate
    
    func didLostUser(userID: String) {
        delegate?.didLostUser(withID: userID)
        conversation?.didLostUser(withID: userID)
    }
    
    func didFoundUser(userID: String, userName: String?) {
        delegate?.didFoundUser(name: userName ?? "noname", withID: userID)
    }
    
    func didReceiveMessage(text: String, fromUser sender: String, toUser: String) {
        delegate?.didReceiveMessage(text: text, fromUser: sender)
        conversation?.didReceiveMessage(text: text, fromUser: sender)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
}
