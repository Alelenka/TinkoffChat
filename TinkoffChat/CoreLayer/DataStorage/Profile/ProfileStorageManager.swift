//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 04.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ProfileStorageManager: IProfileProtocol {
    
    let stack: ICoreDataStack
    
    init(withStack stack: ICoreDataStack) {
        self.stack = stack
    }
    
    func save(profile: ProfileData, completion: @escaping (_ result: Bool) -> ()) {
        guard let appUser = AppUser.findOrInsertAppUser(in: stack.context) else {
            completion(false)
            return
        }
        guard let user = appUser.currentUser else {
            completion(false)
            return
        }
        
        stack.context.perform {
            user.name = profile.profileName
            user.info = profile.profileDescription
            
            let photoData = UIImagePNGRepresentation(profile.profileImage)
            user.photo = photoData
        
        
            self.stack.save(context: self.stack.context) { (result) in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
        
 
    func load(completion: @escaping (ProfileData?) -> Void) {
        stack.mainContext.perform {
            
            guard let appUser = AppUser.findOrInsertAppUser(in: self.stack.context) else {
                completion(nil)
                return
            }
            guard let user = appUser.currentUser else {
                completion(nil)
                return
            }
            
            var image = #imageLiteral(resourceName: "demo-user")
            if let photoData = user.photo {
                image = UIImage(data: photoData as Data)!
            }
            let profile = ProfileData.init(with: user.name, description: user.info, image: image)
            
            completion(profile)
        }
    }
}
