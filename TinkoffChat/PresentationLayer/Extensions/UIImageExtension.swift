//
//  UIImageExtension.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 04.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {

    func isImageEqual(newImage: UIImage) -> Bool {
        let oldData = UIImagePNGRepresentation(self)
        let newData = UIImagePNGRepresentation(newImage)
        return oldData == newData
    }
}
