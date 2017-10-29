//
//  ConvesationModel.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol IConversationModel: class {
    weak var delegate: IConversationModelDelegate? { get set }
    var userID: String { get set }
    var userName: String { get set }
    func sendMessage(string text: String, completionHandler: (() -> ())?)
    func markAsRead()
}

protocol IConversationModelDelegate: class {
    func userWentOffline()
    func setup(dataSource: [Message])
}

class ConversationModel: IConversationModel, ICommunicationServiceDelegate {
    
    weak var delegate: IConversationModelDelegate?
    var communicationService: ICommunicationService
    var messageSenderService: IConvesationService
    var userID: String
    var userName: String
    
    init(communicationService: ICommunicationService, messageSenderService: IConvesationService, userID: String, userName: String) {
        self.communicationService = communicationService
        self.messageSenderService = messageSenderService
        self.userID = userID
        self.userName = userName
    }
    
    var messageHistory = [Message]() {
        didSet {
            delegate?.setup(dataSource: messageHistory)
        }
    }
    
    func sendMessage(string text: String, completionHandler: (() -> ())?) {
        messageSenderService.sendMessage(string: text, to: userID) { (success: Bool, error: Error?) in
            
            if let error = error {
                print("Error sending message: \(error)")
            } else if success {
                let newMessage = Message.init(withText: text, user: "")!
                newMessage.incoming = false
                self.messageHistory.append(newMessage)
            } else {
                print("Error sending message: unknown error")
            }
            
            DispatchQueue.main.async {
                completionHandler?()
            }
        }
    }
    
    func markAsRead() {
        communicationService.markConversationAsRead(withUserID: userID)
    }
    
    // MARK: - CommunicationServiceDelegate
    
    func didLostUser(withID userID: String) {
        if userID == self.userID {
            delegate?.userWentOffline()
        }
    }
    
    func didReceiveMessage(text: String, fromUser userID: String) {
        if userID == self.userID {
            let newMessage = Message.init(withText: text, user: userID)!
            newMessage.incoming = true
            messageHistory.append(newMessage)
        }
    }
}
