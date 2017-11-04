//
//  ConversationListAssembly.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

class ConversationsListAssembly {
    
    private var dataStorage: ConversationStorage
    
    init(with storage: ConversationStorage){
        self.dataStorage = storage
    }
    
    func conversationsListViewController() -> UINavigationController {
        
        let storyboard = UIStoryboard(name: "ConversationsList", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = navigationController.viewControllers.first as! ConversationsListViewController
        let model = conversationsListModel(withStorage: dataStorage)
        model.delegate = vc
        vc.model = model
        
        return navigationController
    }
    
    func conversationsListModel(withStorage dataStorage: ConversationStorage) -> IConversationsListModel {

        let currentCommunicationService = communicationService(withStorage: dataStorage)
        let conversationsListModel = ConversationsListModel.init(communicationService: currentCommunicationService)
        currentCommunicationService.delegate = conversationsListModel

        return conversationsListModel
    }

    func communicationService(withStorage dataStorage: ConversationStorage) -> ICommunicationService {

        let messageLoader = MessageLoader.init(parser: MessageParser(), maker: MessageMaker())
        let communicator = MultipeerCommunicator.init(withMessageLoader: messageLoader)
        let communicationService = CommunicationService(communicator: communicator, conversationStorage: dataStorage)
        communicator.delegate = communicationService
        return communicationService
    }
}

