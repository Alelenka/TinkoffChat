//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 06.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let showConversationSegue = "ShowDialogSegue"
    private let showProfileSegue = "ShowProfileSegue"
    var model: IConversationsListModel?
    private var dataSource = [ConversationsListCellDisplayModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.communicationService.setAllUsersOffline {
            self.model?.communicationService.fetchedResuts.tableView = self.tableView
            self.tableView.rowHeight =  UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = 50.0
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let num = model?.getRowsIn(section: section) {
            return num
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ConversationsCell
        
        guard let conversation = model?.getConversation(at: indexPath) else {
            return cell
        }
        
        cell.name = conversation.name
        cell.date = conversation.date
        cell.online = true
        cell.hasUnreadMessages = conversation.hasUnreadMessages

        if let message = conversation.message {
            cell.message = message
        } else {
            cell.message = ""
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        } else {
            return "History"
        }
    }
    
     // MARK: - TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showConversationSegue {
            guard let conversationVC = segue.destination as? ConversationViewController else {
                print("Storyboard error")
                return
            }
            guard let communicationService = model?.communicationService else {
                print("Error list model")
                return
            }
            if let index = tableView.indexPathForSelectedRow {
                if let conversation = model?.getConversation(at: index),
                    let id = conversation.conversationID {
                    RootAssembly.conversationModule.setup(inViewController: conversationVC, communicationService: communicationService, conversationID: id)
                }
                
            }

        } else if segue.identifier == showProfileSegue {
            guard let navigationVC = segue.destination as? UINavigationController else {
                print("Storyboard error")
                return
            }
            guard let profileVC = navigationVC.viewControllers.first as? ProfileViewController else {
                print("Storyboard profile error")
                return
            }
            
            RootAssembly.profileModule.setup(inViewController: profileVC)
        }
    }
    
}
