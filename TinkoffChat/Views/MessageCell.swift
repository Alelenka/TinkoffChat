//
//  MessageCell.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 08.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration : class {
    var mess: String? {get set}
    //    var text: String? // Cannot override with a stored deprecated property 'text'
}

class MessageCell: UITableViewCell , MessageCellConfiguration {

    @IBOutlet weak var messageTextLabel: UILabel!
    
    var mess: String? {
        get {
            return self.mess
        }
        
        set (newValue) {
            self.messageTextLabel?.text =  newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell<T: MessageCellConfiguration>(info: T) {
        messageTextLabel?.text = info.mess
    }

}
