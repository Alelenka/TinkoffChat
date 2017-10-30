//
//  ConversationAssembly.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

class ConversationAssembly {
    
    var dataStorage: ConversationStorage? // ??????
    
    func setup(inViewController vc: ConversationViewController, communicationService: ICommunicationService, userID: String) {
        if let storage = dataStorage {
            let model = conversationModel(communicationService: communicationService, dataStorage: storage, userID: userID)
            vc.model = model
            model.delegate = vc
        }
    }
    
    private func conversationModel(communicationService: ICommunicationService, dataStorage: ConversationStorage, userID: String) -> IConversationModel {
        let service = conversationSercive(communicator: communicationService.communicator, storage: dataStorage)
        let conversationModel = ConversationModel.init(communicationService: communicationService, conversationService:service, userID: userID)
        communicationService.conversation = conversationModel
        conversationModel.conversationService.delegate = conversationModel

        return conversationModel
    }
    
    private func conversationSercive(communicator: ICommunicator, storage: ConversationStorage) -> ConversationService {
        return ConversationService.init(communicator: communicator, storage: storage)
    }
    
}
