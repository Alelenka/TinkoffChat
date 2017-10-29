//
//  ConversationsCell.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 08.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

protocol ConversationsCellConfiguration : class {
    var name : String? {get set}
    var message : String? {get set}
    var date: Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessages : Bool {get set}
}

class ConversationsCell: UITableViewCell, ConversationsCellConfiguration {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastTimeLabel: UILabel!
    @IBOutlet weak var textMessageLabel: UILabel!
    
    var name : String? {
        get {
            return self.name
        }
        
        set (newValue) {
            self.nameLabel?.text =  newValue
        }
    }
    var message : String? {
        get {
            return self.message
        }
        
        set (newValue) {
            guard let messageText = newValue else { // guard
                self.textMessageLabel?.text = "No message yet"
                return
            }
            if (messageText.isEmpty){
                 self.textMessageLabel?.text = "No message yet"
            } else {
                self.textMessageLabel?.text = messageText
            }
            //TODO: NO message yet c пустым сообщением
        }
        
    }
    var date: Date? {
        get {
            return self.date
        }
        
        set (newValue) {
            if let concreteDate = newValue {
                lastTimeLabel.text = concreteDate.toHhMmString()
            } else {
                lastTimeLabel.text = ""
            }
        }
        
    }
    var online : Bool {
        get {
        return self.online
        }
        
        set (newValue) {
            if newValue {
                contentView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 192.0/225.0, alpha: 1.0)
            } else {
                contentView.backgroundColor = UIColor.white
            }
        }
        
    }
    var hasUnreadMessages : Bool {
        get {
            return self.hasUnreadMessages
        }
        
        set (newValue) {
            if (newValue){
                textMessageLabel.font = UIFont.boldSystemFont(ofSize: textMessageLabel.font.pointSize)
            } else {
                textMessageLabel.font = UIFont.systemFont(ofSize: textMessageLabel.font.pointSize)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
