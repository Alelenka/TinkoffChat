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
    
    func conversationsListViewController() -> UINavigationController {
        
        let storyboard = UIStoryboard(name: "ConversationsList", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let vc = navigationController.viewControllers.first as! ConversationsListViewController
        let model = conversationsListModel()
        model.delegate = vc
        vc.model = model
        
        return navigationController
    }
    
    func conversationsListModel() -> IConversationsListModel {

        let currentCommunicationService = communicationService()
        let conversationsListModel = ConversationsListModel.init(communicationService: currentCommunicationService)
        currentCommunicationService.delegate = conversationsListModel

        return conversationsListModel
    }

    func communicationService() -> ICommunicationService {

        let messageLoader = MessageLoader.init(parser: MessageParser(), maker: MessageMaker())
        let communicator = MultipeerCommunicator.init(withMessageLoader: messageLoader)
        let communicationService = CommunicationService(communicator: communicator)
        communicator.delegate = communicationService
        return communicationService
    }
}

