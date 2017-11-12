//
//  ProfileAssembly.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

class ProfileAssembly {
    
    var dataStack: ICoreDataStack
    
    init(with stack: ICoreDataStack) {
        self.dataStack = stack
    }
    
    func setup(inViewController vc: ProfileViewController) {
        let model = ProfileModel.init(profileService: profileService())
        vc.model = model
    }
    
    private func profileService() -> IProfileService {
        let storage = storageManager()
        return ProfileService.init(withManagers: GCDDataManader(), operation: OperationDataManager(), storage: storage)
    }
    
    private func storageManager() -> ProfileStorageManager {
        return ProfileStorageManager.init(withStack: dataStack)
    }
}
