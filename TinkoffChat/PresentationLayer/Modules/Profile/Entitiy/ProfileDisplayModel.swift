//
//  ProfileDisplayModel.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 04.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

struct ProfileDisplayModel {
    var name: String?
    var info: String?
    var photo: UIImage
    
    static func defaultProfile() -> ProfileDisplayModel {
        let name = "Иван Иванович"
        let userInfo = "Чем-то занят"
        return ProfileDisplayModel(name: name, info: userInfo, photo: #imageLiteral(resourceName: "demo-user"))
    }
}

extension ProfileDisplayModel: Equatable {
    static func == (lhs: ProfileDisplayModel, rhs: ProfileDisplayModel) -> Bool {
        return lhs.name == rhs.name && lhs.info == rhs.info && (lhs.photo.isImageEqual(newImage: rhs.photo))
    }
}
