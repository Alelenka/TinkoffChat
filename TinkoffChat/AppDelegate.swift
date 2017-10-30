//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 20.09.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let rootAssembly = RootAssembly()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        logApplicationInfo(stateFrom: "Not running")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let controller = rootAssembly.conversationListModule.conversationsListViewController(withStorage: rootAssembly.conversationStorage)
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        logApplicationInfo(stateTo: "inactive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        logApplicationInfo(stateFrom: "inactive")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        logApplicationInfo(stateTo: "inactive")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        logApplicationInfo(stateFrom: "inactive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        logApplicationInfo(stateTo: "Suspended")
    }

    private func logApplicationInfo( stateTo: String, string: String = #function) {
        logInfo(stateFrom: applicationStateString(), stateTo: stateTo, string: string);
    }

    private func logApplicationInfo( stateFrom: String, string: String = #function) {
        logInfo(stateFrom: stateFrom, stateTo: applicationStateString(), string: string);
    }
    
    private func applicationStateString() -> String {
        let state: UIApplicationState = UIApplication.shared.applicationState
        var stateStr = ""
        
        switch state {
        case .background:
            stateStr = "background"
        case .inactive:
            stateStr = "inactive"
        case .active:
            stateStr = "active"
        }
        
        return stateStr;
    }
    
    private func logInfo ( stateFrom: String, stateTo: String, string: String = #function) {
        print("Application moved from \(stateFrom) to \(stateTo) state: \(string)")
    }
}

