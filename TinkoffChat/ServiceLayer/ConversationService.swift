//
//  ConversationService.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol IConvesationService: class {
    var communicator: ICommunicator { get set }
    func sendMessage(string text: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
}

class ConvesationService: IConvesationService {
    
    var communicator: ICommunicator
    
    init(communicator: ICommunicator) {
        self.communicator = communicator
    }
    
    func sendMessage(string text: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        communicator.sendMessage(string: text, to: userID, completionHandler: completionHandler)
    }
}
