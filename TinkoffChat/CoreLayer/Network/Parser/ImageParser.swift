//
//  ImageParser.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 19.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

struct ImageModel {
    let image: UIImage
}

class ImageParser: Parser<ImageModel> {
    
    typealias Model = ImageModel
    
    override func parse(data: Data) -> ImageModel? {
        
        guard let image = UIImage(data: data) else {
            return nil
        }
        
        return ImageModel(image: image)
    }
}
