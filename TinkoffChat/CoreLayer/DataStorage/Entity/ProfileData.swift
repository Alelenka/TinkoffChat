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
    var profileImage: UIImage?
    
    var changed: Bool = false
    
    init() {
        profileName = "Имя"
        profileDescription = "Описание"
        profileImage = UIImage.init(named: "demo-user")
    }
    
    init(with name: String?, description: String?, image: UIImage?) {
        
        let newName: String = name ?? "Имя"
        profileName = newName
        let newDescription: String = description ?? "Описание"
        profileDescription = newDescription
        let img = image ?? UIImage.init(named: "demo-user")
        profileImage = img
    }
    
    init(with data: [String: String]) {
        let newName: String = data["name"] ?? "Имя"
        profileName = newName
        let newDescription: String = data["description"] ?? "Описание"
        profileDescription = newDescription
        
        if let imageCode: String = data["image"], let imageData = Data(base64Encoded: imageCode, options: .ignoreUnknownCharacters){
            let img = UIImage(data: imageData) ?? UIImage.init(named: "demo-user")
            profileImage = img
        } else {
            profileImage = UIImage.init(named: "demo-user")
        }
        
    }
    
    func getSavingData() -> Data {
        
        var strBase64 = ""
        if let image = profileImage {
            let imageData:Data = UIImagePNGRepresentation(image)!
            strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        }
        
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
    
    
    func isImageEqual(newImage: UIImage) -> Bool {
        if let image = profileImage {
            let oldData = UIImagePNGRepresentation(image)
            let newData = UIImagePNGRepresentation(newImage)
            return oldData == newData
        }
        return false
        
    }
    
}
