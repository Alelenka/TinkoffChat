//
//  ProfileService.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol IProfileService {
    func save(profile: ProfileData, managerType: ProfileManagerType, completionHandler: @escaping(_ result: Bool) -> ())
    func load(managerType: ProfileManagerType, completionHandler: @escaping (ProfileData?) -> ())
}

class ProfileService: IProfileService {
    
    private let gcdManager: GCDDataManader
    private let operationManger: OperationDataManager
    
    init(withManagers gcd: GCDDataManader, operation: OperationDataManager) {
        self.gcdManager = gcd
        self.operationManger = operation
    }
    
    func save(profile: ProfileData, managerType: ProfileManagerType, completionHandler: @escaping (Bool) -> ()) {
        if let manager = dataManager(with: managerType) {
            manager.save(profile: profile, completion: completionHandler)
        }
    }
    
    func load(managerType: ProfileManagerType, completionHandler: @escaping (ProfileData?) -> ()) {
        if let manager = dataManager(with: managerType) {
            manager.load(completion: completionHandler)
        }
    }

    private func dataManager(with type: ProfileManagerType) -> IProfileProtocol? {
        if type == .GCD {
            return gcdManager
        } else if type == .operationQueue {
            return operationManger
        } else {
            print("Unknown DataManager")
            return nil
        }
    }
    
}
