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
    
    var dataStorage: ConversationStorage
    
    init(with storage: ConversationStorage) {
        self.dataStorage = storage
    }
    
    func setup(inViewController vc: ConversationViewController, communicationService: ICommunicationService, conversationID: String) {
        let model = conversationModel(communicationService: communicationService, dataStorage: dataStorage, conversationID: conversationID)
        vc.model = model
        model.delegate = vc
    }
    
    private func conversationModel(communicationService: ICommunicationService, dataStorage: ConversationStorage, conversationID: String) -> IConversationModel {
        let service = conversationSercive(communicator: communicationService.communicator, storage: dataStorage, conversationID: conversationID)
        let conversationModel = ConversationModel.init(communicationService: communicationService, conversationService:service, conversationID: conversationID)
        communicationService.conversation = conversationModel
        service.delegate = conversationModel

        return conversationModel
    }
    
    private func conversationSercive(communicator: ICommunicator, storage: ConversationStorage, conversationID: String) -> ConversationService {
        return ConversationService.init(communicator: communicator, storage: storage, conversationID: conversationID)
    }
    
}
