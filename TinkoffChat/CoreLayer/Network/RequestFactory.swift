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
//        static func cosmosImages(page: Int) -> RequestConfig<ImageListParser> {
//            return RequestConfig<ImageListParser>(request: CosmosImageListRequest(pageNumber: page), parser: ImageListParser())
//        }
        
        static func cosmosImages(page: Int) -> RequestConfig<[ImageListModel]> {
            return RequestConfig<[ImageListModel]>(request: CosmosImageListRequest(pageNumber: page), parser: ImageListParser())
        }
    }
    
    struct photoRequests {
//        static func imageConfig(withURL imageURL: String) -> RequestConfig<ImageParser> {
//            return RequestConfig<ImageParser>(request: ImageRequest(photoUrl: imageURL), parser: ImageParser())
//        }
        static func imageConfig(withURL imageURL: String) -> RequestConfig<ImageModel> {
            return RequestConfig<ImageModel>(request: ImageRequest(photoUrl: imageURL), parser: ImageParser())
        }
    }
}
