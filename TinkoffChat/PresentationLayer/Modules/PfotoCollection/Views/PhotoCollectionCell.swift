//
//  PhotoCollectionCell.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 18.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

protocol PhotoCollectionCellConfiguration : class {
    var photo: UIImage? {get set}
}

class PhotoCollectionCell: UICollectionViewCell, PhotoCollectionCellConfiguration {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo : UIImage? {
        get {
            return self.photoImageView?.image
        }
        
        set (newValue) {
            if (newValue == nil){
                
            } else {
                self.photoImageView?.image =  newValue
            }
        }
    }
}
