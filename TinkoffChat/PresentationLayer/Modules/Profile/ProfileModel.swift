//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

enum ProfileManagerType {
    case GCD
    case operationQueue
}

protocol IProfileModel {
    var profileChanged: Bool { get }
    func update(profile: ProfileDisplayModel)
    func save(managerType: ProfileManagerType, completionHandler: @escaping(Bool) -> ())
    func load(managerType: ProfileManagerType, completionHandler: @escaping (ProfileDisplayModel) ->())
}

class ProfileModel: IProfileModel {

    let profileService: IProfileService
    private var currentProfile: ProfileDisplayModel
    private var changedProfile: ProfileDisplayModel
    
    var profileChanged: Bool {
        return currentProfile != changedProfile
    }
    
    init(profileService: IProfileService) {
        self.profileService = profileService
        currentProfile = ProfileDisplayModel.defaultProfile()
        changedProfile = currentProfile
    }
    
    func save(managerType: ProfileManagerType, completionHandler: @escaping (Bool) -> ()) {
        let profileData = ProfileData.init(with: changedProfile.name, description: changedProfile.info, image: changedProfile.photo)
        
        profileService.save(profile: profileData, managerType: managerType, completionHandler: completionHandler)
    }
    
    func load(managerType: ProfileManagerType, completionHandler: @escaping (ProfileDisplayModel) -> ()) {
        profileService.load(managerType: managerType) { (profileData) in
            if let profile = profileData {
                self.currentProfile = ProfileDisplayModel(name: profile.profileName, info: profile.profileDescription, photo: profile.profileImage)
            } else {
                self.currentProfile = ProfileDisplayModel.defaultProfile()
            }
            self.changedProfile = self.currentProfile
            completionHandler(self.currentProfile)
        }
    }
    
    func update(profile: ProfileDisplayModel) {
        changedProfile = profile
    }
    
}
