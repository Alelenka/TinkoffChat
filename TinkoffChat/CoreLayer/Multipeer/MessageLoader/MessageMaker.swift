//
//  MessageMaker.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol IMessageMaker {
    func createMessage(text: String) -> Data?
}

class MessageMaker: IMessageMaker {
    
    func createMessage(text: String) -> Data? {
        let messageId = generateMessageId()
        let messageJson = [
            "eventType" : "TextMessage",
            "messageId" : messageId,
            "text"      : text
        ]
        
        do {
            let messageData = try JSONSerialization.data(withJSONObject: messageJson, options: [])
            return messageData
        } catch {
            print("Error creating message json: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: generate ID
    
    private func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }

}
