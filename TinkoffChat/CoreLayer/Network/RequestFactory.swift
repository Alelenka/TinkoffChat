//
//  RequestFactory.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 19.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    struct pixabayRequests {
        static func cosmosImages(page: Int) -> RequestCongig<ImageListParser> {
            return RequestCongig<ImageListParser>(request: CosmosImageListRequest(pageNumber: page), parser: ImageListParser())
        }
    }
    
    struct photoRequests {
        static func imageConfig(withURL imageURL: String) -> RequestCongig<ImageParser> {
            return RequestCongig<ImageParser>(request: ImageRequest(photoUrl: imageURL), parser: ImageParser())
        }
    }
}
