//
//  MessageParser.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol IMessageParser {
    func getMessage(fromData data: Data) -> String?
}

class MessageParser: IMessageParser {
    private let messageEvent = "TextMessage"
    
    func getMessage(fromData data: Data) -> String? {
        do {
            guard let messageJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [ String : String ] else {
                print("Error parsing message json: eventType != \(messageEvent)")
                return nil
            }
            guard messageJson["eventType"] == messageEvent else {
                return nil
            }
            guard let messageText = messageJson["text"] else {
                print("Error parsing message json: no text")
                return nil
            }
            print("%@", messageJson)
            return messageText
        } catch {
            print("Error parsing message json: \(error.localizedDescription)")
            return nil
        }
    }
}
