//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 08.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ConversationsManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let conversationManager = ConversationsManager.shared
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conversationManager.conversationDelegate = self
        tableView.rowHeight =  UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        
        messageTextField.delegate = self
        navigationController?.navigationBar.tintColor = .black
//        sendButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        if let conversation = conversationManager.currentConversation {
            navigationItem.title = conversation.name
            messages = conversation.messages
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        conversationManager.forgetCurrentConversation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        var identifier = "OutgoingMessage"
        if message.incoming {
            identifier = "IcomingMessage"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageCell
        cell.message = message.text
        return cell
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        messageTextField.resignFirstResponder()
        
        if let str = messageTextField.text {
            if str.count > 0 {
                let message = Message.init(withText: messageTextField.text!, user: UUID().uuidString)
                message?.incoming = false
                conversationManager.send(message!)
                messageTextField.text = ""
            }
        }
    }
    
    // MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.bottomConstraint?.constant = 0.0
            } else {
                if let keyboardHeignt = endFrame?.size.height {
                    self.bottomConstraint?.constant = keyboardHeignt
                }
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    // MARK: ConversationDelegate
    func updateConversationsList() {
        checkUserOnline()
    }
    
    func updateCurrentConversation() {
        checkUserOnline()
        if let conversation = conversationManager.currentConversation {
            messages = conversation.messages
        }
        tableView.reloadData()
        //reload
    }
    
    func checkUserOnline() {
        if (conversationManager.currentConversation == nil){
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
}
