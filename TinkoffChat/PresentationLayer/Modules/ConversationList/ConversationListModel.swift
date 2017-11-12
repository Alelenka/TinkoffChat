//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

struct ConversationsListCellDisplayModel {
    var conversationID: String?
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool = false
    var hasUnreadMessages: Bool = false
}

protocol IConversationsListModel: class {
    var communicationService: ICommunicationService { get set }
    func setAllUsersOffline(completionHandler: @escaping () -> () )
    func getSections() -> Int
    func getRowsIn(section: Int) -> Int
    func getConversation(at indexPath: IndexPath) -> ConversationsListCellDisplayModel
}

class ConversationsListModel: IConversationsListModel {
    
    var communicationService: ICommunicationService
    
    init(communicationService: ICommunicationService) {
        self.communicationService = communicationService
    }
    
    // MARK: - FRC
    func getSections() -> Int {
        guard let frc = communicationService.fetchedResuts.frc,
            let sectionsCount = frc.sections?.count else {
                return 0
        }
        return sectionsCount
    }
    
    func getRowsIn(section: Int) -> Int {
        guard let frc = communicationService.fetchedResuts.frc,
            let sections = frc.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func getConversation(at indexPath: IndexPath) -> ConversationsListCellDisplayModel {
        if let conversation = communicationService.fetchedResuts.frc?.object(at: indexPath) {
            
            let conversationsListCellDisplayModel = ConversationsListCellDisplayModel(
                conversationID: conversation.conversationID,
                name: conversation.user?.name,
                message: conversation.lastMessage?.text,
                date: conversation.lastMessage?.date,
                online: conversation.user?.isOnline ?? false,
                hasUnreadMessages: conversation.hasUnreadMessage)
            return conversationsListCellDisplayModel
        }
        
        return ConversationsListCellDisplayModel()
    }
    
    func setAllUsersOffline(completionHandler: @escaping () -> () ){
        communicationService.setAllUsersOffline {
            completionHandler()
        }
    }
}
