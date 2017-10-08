//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 08.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    
    let demoContent = ["!", "?", "Сколько лет прошло, все о том же гудят провода\nВсе того же ждут самолеты\nДевочка с глазами из самого синего льда\nТает под огнем пулемета, должен же растаять хоть кто-то.\n\nСкоро рассвет, выхода нет\nКлюч поверни - и полетели\nНужно вписать в чью-то тетрадь\nКровью, как в метрополитене:\nВыхода нет, выхода нет.", "Где-то мы расстались - не помню в каких городах", "Словно это было в похмелье", "Через мои песни идут, идут поезда\nИсчезая в темном тоннеле, лишь бы мы проснулись в одной постели.\n\nСкоро рассвет, выхода нет\nКлюч поверни - и полетели\nНужно вписать в чью-то тетрадь\nКровью, как в метрополитене:\nВыхода нет, выхода нет."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight =  UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0;
        
        navigationController?.navigationBar.tintColor = .black
//        navigationItem.title = "Jq jqjqjq"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var identifier = "IcomingMessage"
        if indexPath.row % 2 == 0 {
            identifier = "OutgoingMessage"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
//        cell.configureCell(info:)        
        cell.mess = demoContent[indexPath.row]
        return cell
    }
    
}
