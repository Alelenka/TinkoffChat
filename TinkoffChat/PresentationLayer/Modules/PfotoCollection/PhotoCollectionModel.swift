//
//  PhotoCollectionModel.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 18.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

struct PhotoCellDisplayModel {
    var image: UIImage
}

protocol IPhotoCollectionModel: class {
    func getCountOfRows() -> Int
    func fetchImages(completionHandler: @escaping (Bool) -> () )
    func getPhoto(at index: Int, completionHandler: @escaping (PhotoCellDisplayModel) -> () )
}

class PhotoCollectionModel: IPhotoCollectionModel {
    
    let loadService: ILoadImageService
    var imageUrls: [ImageListModel] = []
    
    init(loadService: ILoadImageService) {
        self.loadService = loadService
    }
    
    func fetchImages(completionHandler: @escaping (Bool) -> () ){
        
        let page: Int = imageUrls.count / 40 + 1
        
        loadService.loadImageList(page: page) { (urls, error) in
            if let urls = urls {
                self.imageUrls.append(contentsOf: urls);
                completionHandler(true)
            } else {
                print(error ?? "Error")
                completionHandler(false)
            }
        }
    }
    
    func getCountOfRows() -> Int {
        return imageUrls.count
    }
    
    func getPhoto(at index: Int, completionHandler: @escaping (PhotoCellDisplayModel) -> ()) {
        let model = imageUrls[index]
        
        loadService.loadImage(withURL: model.urlString) { (model, error) in
            
            if let model = model {
                let photoCellModel = PhotoCellDisplayModel.init(image: model.image)
                completionHandler(photoCellModel)
            } else {
                print(error ?? "Error")
                completionHandler(PhotoCellDisplayModel.init(image: #imageLiteral(resourceName: "placeholder")))
            }
        }
    }
    
}
