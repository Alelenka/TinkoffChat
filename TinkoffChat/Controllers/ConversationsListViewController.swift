//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 06.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var arrayOnline : [ConversationElement] = []
    var arrayOffline : [ConversationElement] = []
    
    let showSegue = "ShowDialogSegue"

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight =  UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0;
        
        self.readJson()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Temporary Model Methods //позже будут вынесены в модель
    func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "tChat", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let objects = json as? [Any] {
                    
                    for conversation in objects {
                        if let conv = conversation as? [String: Any] {
                            let element = ConversationElement.init(json: conv)
                            
                            if let el = element {
                                if el.online {
                                    arrayOnline.append(el)
                                } else {
                                    arrayOffline.append(el)
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async{
                        self.tableView.reloadData()
                    }
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    // MARK: - TableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return arrayOnline.count
        } else {
            return arrayOffline.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ConversationsCell
        let element : ConversationElement;
        
        if (indexPath.section == 0) {
            element =  arrayOnline[indexPath.row]
        } else {
            element =  arrayOffline[indexPath.row]
        }
        
        cell.name = element.name
        cell.message = element.message
        cell.date = element.date
        cell.online = element.online
        cell.hasUnreadMessages = element.hasUnreadMessages
        
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
            let destination = segue.destination
            var title : String?
            
            if let index = tableView.indexPathForSelectedRow {
                if index.section == 0 {
                    title =  arrayOnline[index.row].name
                } else {
                    title =  arrayOffline[index.row].name
                }
        }
            
            destination.navigationItem.title = title
        }
    }
    
}
