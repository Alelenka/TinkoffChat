//
//  LoadImageService.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 19.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

protocol ILoadImageService {
    func loadImageList(page: Int, completionHandler: @escaping ([ImageListModel]?, String?) -> () )
    func loadImage(withURL urlString: String, completionHandler: @escaping (ImageModel?, String?) -> () )

}

class LoadImageService: ILoadImageService {
    
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadImageList(page: Int, completionHandler: @escaping ([ImageListModel]?, String?) -> ()) {
        let requestConfig = RequestsFactory.pixabayRequests.cosmosImages(page: page)
        
        requestSender.send(config: requestConfig, completionHandler: { (result) in
            self.onResult(result: result, completionHandler: completionHandler)
        })
    }
    
    func loadImage(withURL urlString: String, completionHandler: @escaping (ImageModel?, String?) -> ()) {
        let requestConfig = RequestsFactory.photoRequests.imageConfig(withURL: urlString)
        
        requestSender.send(config: requestConfig) { (result) in
            self.onResult(result: result, completionHandler: completionHandler)
        }
    }
    
    private func onResult<T>(result: Result<T>, completionHandler: @escaping (T?, String?) -> () ) {
        
        switch result {
        case .success(let result):
            completionHandler(result, nil)
        case .error(let error):
            completionHandler(nil, error)
        }
    }
}
