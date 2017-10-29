//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 22.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

enum CommunicatorError: Error {
    case internalCommunicatorError
    case generateMessageCommunicatorError
    case sendCommunicatorError
}

protocol ICommunicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    weak var delegate: ICommunicatorDelegate? {get set}
    var online: Bool {get set}
}

protocol ICommunicatorDelegate: class {
    //discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}
