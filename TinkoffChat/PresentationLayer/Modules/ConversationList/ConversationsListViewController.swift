//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 06.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IConversationsListModelDelegate {

    private let showSegue = "ShowDialogSegue"
    var model: IConversationsListModel?
    private var dataSource = [ConversationsListCellDisplayModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight =  UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        tableView.delegate = self
        tableView.dataSource = self
//        conversationManager.listDelegate = self
//        communicator.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup(dataSource: [ConversationsListCellDisplayModel]) {
        self.dataSource = dataSource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ConversationsCell
        let conversation = dataSource[indexPath.row]
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
        
        if segue.identifier == showSegue {
            guard let conversationVC = segue.destination as? ConversationViewController else {
                print("Storyboard error")
                return
            }
            
            guard let communicationService = model?.communicationService else {
                print("Error list model")
                return
            }
            
            if let index = tableView.indexPathForSelectedRow {
                let conversation = dataSource[index.row]
                let conversationAssembler = ConversationAssembly()
                let userID = conversation.userID
                
                conversationAssembler.setup(inViewController: conversationVC, communicationService: communicationService, userID: userID)
            }
        }
    }
    
}
