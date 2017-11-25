//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 08.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ConversationViewController: AnimationViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, IConversationModelDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var userOnline = true
    private var messageStarted = false
    
    var model: IConversationModel?
    private var dataSource = [MessageCellDisplayModel]()
    private let titleLabel = ConverasionTitleLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model?.conversationService.fetchedResuts.tableView = tableView
        tableView.rowHeight =  UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        
        messageTextField.delegate = self
        navigationController?.navigationBar.tintColor = .black

        titleLabel.text = model?.userName
        navigationItem.titleView = titleLabel
        navigationItem.titleView?.sizeToFit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        titleLabel.setOnline(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        model?.markAsRead()
        NotificationCenter.default.removeObserver(self)
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
        
        guard let message = model?.getConversation(at: indexPath) else {
            return UITableViewCell()
        }
        
        var identifier = "OutgoingMessage"
        if message.inbox {
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
                model?.sendMessage(string: str)
                messageTextField.text = ""
                messageStarted = false
            }
        }
    }
    
    // MARK: - TextField

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            
            if txtAfterUpdate.isEmpty {
                messageStarted = false
            } else {
                messageStarted = true
            }
            updateSendButton()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame.origin.y >= UIScreen.main.bounds.size.height {
                self.bottomConstraint?.constant = 0.0
            } else {
                self.bottomConstraint?.constant = endFrame.size.height
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    // MARK: - ModelDelegate
    func userStateChanged(online: Bool) {
        DispatchQueue.main.async {
            self.userOnline = online
            self.titleLabel.setOnline(online)
            self.updateSendButton()
        }
    }
    
    private func updateSendButton() {
        let newValue = userOnline && messageStarted;
        if newValue != sendButton.isEnabled {
            sendButton.isEnabled = newValue
        }
        
    }

}
