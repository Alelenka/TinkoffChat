//
//  PhotoCollectionAssembly.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 18.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class PhotoCollectionAssembly {
    
    func setup(inViewController vc: PhotoCollectionController) {
        let model = PhotoCollectionModel(loadService: loadService())
        vc.model = model
    }
    
    private func loadService() -> ILoadImageService {
        return LoadImageService(requestSender: requestSender())
    }
    
    private func requestSender() -> IRequestSender {
        return RequestSender()
    }
}
