//
//  ConversationAssembly.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class ConversationAssembly {
    
    func setup(inViewController vc: ConversationViewController, communicationService: ICommunitationService, userID: String, userName: String) {
        
        let model = conversationModel(communicationService: communicationService,
                                      userID: userID,
                                      userName: userName)
        vc.model = model
        model.delegate = vc
    }
    
    private func conversationModel(communicationService: ICommunitationService, userID: String, userName: String) -> IConversationModel {
        
        let conversationModel = ConversationModel(communicationService: communicationService,
                                                  messageSenderService: MessageSenderService(communicator: communicationService.communicator),
                                                  userID: userID,
                                                  userName: userName)
        communicationService.conversation = conversationModel
        
        return conversationModel
    }
    
    private func messageSender(_ communicator: ICommunicator) -> IMessageSenderService {
        return MessageSenderService(communicator: communicator)
    }
}
