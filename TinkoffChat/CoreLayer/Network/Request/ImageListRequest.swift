//
//  ImageListRequest.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 19.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class ImageListRequest: IRequest {
    fileprivate var command: String {
        assertionFailure("❌ Should use a subclass of ImageListRequest ")
        return ""
    }
    
    private var limitString: String {
        return "&per_page=\(limit)"
    }
    
    private var apiKeyString: String {
        return "?key=\(apiKey)"
    }
    
    private var page: String {
        if pageNumber < 2 {
            return ""
        }
        return "&page=\(pageNumber)"
    }

    private let baseUrl = "https://pixabay.com/api/"
    private var limit: Int
    private let apiKey = "7092691-9538f98c30ad683e58f6f0f06"
    private var pageNumber = 0
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        let urlString: String = baseUrl + apiKeyString + command + limitString + page
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        
        return nil
    }
    
    // MARK: - Initialization
    
    init(pageNumber: Int, limit: Int = 40) {
        self.limit = limit
        self.pageNumber = pageNumber
    }

}

class CosmosImageListRequest: ImageListRequest {
    override var command: String { return "&q=cosmos&image_type=illustration&pretty=true" }
}
