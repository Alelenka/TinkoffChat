//
//  ProfileData.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 15.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

class ProfileData {
    var profileName: String 
    var profileDescription: String
    var profileImage: UIImage = #imageLiteral(resourceName: "demo-user")
    
    var changed: Bool = false
    
    init() {
        profileName = "Имя"
        profileDescription = "Описание"
        profileImage = #imageLiteral(resourceName: "demo-user")
    }
    
    init(with name: String?, description: String?, image: UIImage?) {
        profileName = name ?? "Имя"
        profileDescription = description ?? "Описание"
        profileImage = image ?? #imageLiteral(resourceName: "demo-user")
    }
    
    init(with data: [String: String]) {
        let newName: String = data["name"] ?? "Имя"
        profileName = newName
        let newDescription: String = data["description"] ?? "Описание"
        profileDescription = newDescription
        if let imageCode: String = data["image"], let imageData = Data(base64Encoded: imageCode, options: .ignoreUnknownCharacters){
            profileImage = UIImage(data: imageData) ?? #imageLiteral(resourceName: "demo-user")
        } else {
            profileImage = #imageLiteral(resourceName: "demo-user")
        }
        
    }
    
    func getSavingData() -> Data {
        
        var strBase64 = ""
        let imageData:Data = UIImagePNGRepresentation(profileImage)!
        strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let jsonDict : [String : Any] = ["name": profileName,
                                         "description": profileDescription,
                                         "image": strBase64]
        if JSONSerialization.isValidJSONObject(jsonDict) {
            do {
                let rawData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
                
                return rawData
            } catch {
                //error
                return Data()
            }
        } else {
            //error
            return Data()
        }
        
    }
    
}
