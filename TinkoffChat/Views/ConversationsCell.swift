//
//  ConversationsCell.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 08.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

//Протоколу должен будет соответсвовать объект для конфигурации, потому как считаю что ячейка должна заполнятся не в контроллере, а внутри себя
//Соответсвие протоколу для примера сделано в ячейке сообщений
protocol ConversationsCellConfiguration : class {
    var name : String? {get set}
    var message : String? {get set}
    var date: Date? {get set}
    var online : Bool {get set}
    var hasUnreadMessages : Bool {get set}
}

class ConversationsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastTimeLabel: UILabel!
    @IBOutlet weak var textMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell<T: ConversationsCellConfiguration>(info: T) {
        nameLabel?.text = info.name
        
        if let date = info.date {
          lastTimeLabel.text = date.toHhMmString()
        } else {
            lastTimeLabel.text = ""
        }
        
        textMessageLabel?.text = info.message
        if info.online {
            contentView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 192.0/225.0, alpha: 1.0)
        } else {
            contentView.backgroundColor = UIColor.white
        }
        
        if (info.hasUnreadMessages){
            textMessageLabel.font = UIFont.boldSystemFont(ofSize: textMessageLabel.font.pointSize)
        } else {
            textMessageLabel.font = UIFont.systemFont(ofSize: textMessageLabel.font.pointSize)
        }
    }

}
