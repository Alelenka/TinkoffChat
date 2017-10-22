//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 06.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConversationsManagerDelegate {
    
    let showSegue = "ShowDialogSegue"
    
    let conversationManager = ConversationsManager.shared
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight =  UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0;
        conversationManager.listDelegate = self
//        communicator.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationManager.converationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ConversationsCell
        let conversation = conversationManager.converationList[indexPath.row]
        cell.name = conversation.name
        cell.date = conversation.lastMessageDate
        cell.online = true
        cell.hasUnreadMessages = conversation.hasUnreadMessages

        if let message = conversation.messages.last {
            cell.message = message.text
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
        let conversation = conversationManager.converationList[indexPath.row]
        conversation.hasUnreadMessages = false
        
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showSegue {
            let destination = segue.destination
            if let index = tableView.indexPathForSelectedRow {
                let conversation = conversationManager.converationList[index.row]
                conversationManager.selectCurrentConversation(withId: conversation.userId)
                destination.navigationItem.title = conversation.name
            }
        }
    }
    
    // MARK: ConversationDelegate
    
    func updateConversationsList() {
        tableView.reloadData()
    }
    
    func updateCurrentConversation() {
        //do nothing
    }
    
}
