//
//  UserExtensions.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 04.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension User {
    
    static func findOrInsertAppUser(with id: String, in context: NSManagedObjectContext) -> User? {
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.userID = id
            return user
        }
        
        return nil
    }
    
    static var generatedUserIdString: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
}
