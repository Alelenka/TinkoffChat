//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 20.09.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad() // Always
        logInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // Always
        logInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated) // Always
        logInfo()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews() //Not neccessary
        logInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews() //Not neccessary
        logInfo()
    }
    
    override func  viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated) // Always
        logInfo()
    }
    override func  viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated) // Always
        logInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() // Always
//      automated log
    }

    private func logInfo (string: String = #function) {
        print("ViewConstoller method : \(string)")
    }
}

