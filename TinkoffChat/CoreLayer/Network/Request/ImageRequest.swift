//
//  PhotoRequest.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 19.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {
    
    private var photoUrlString: String
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        let urlString: String = photoUrlString
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        
        return nil
    }
    
    // MARK: - Initialization
    
    init(photoUrl: String) {
        self.photoUrlString = photoUrl
    }
    
}
