//
//  PhotoCollectionController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 18.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

protocol PhotoCollectionControllerDelegate: class {
    func photoCollectionController(_ photoCollectionController: PhotoCollectionController, didFinishPickingImage image: UIImage )
}

class PhotoCollectionController: AnimationViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var model: IPhotoCollectionModel?
    weak var delegate: PhotoCollectionControllerDelegate?
    
    private let insets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadImages() {
        model?.fetchImages(completionHandler: { (success) in
            if success {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        });
    }
}

extension PhotoCollectionController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedCell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionCell,
            let image = selectedCell.photo else {
                return
        }
        
        delegate?.photoCollectionController(self, didFinishPickingImage: image)
        self.dismiss(animated: true, completion: nil)
    }
}

extension PhotoCollectionController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let num = model?.getCountOfRows() {
            return num
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseID = "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! PhotoCollectionCell
        
        cell.photo = #imageLiteral(resourceName: "placeholder")
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.model?.getPhoto(at: indexPath.row, completionHandler: { (dispalyModel) in
                DispatchQueue.main.async {
                     cell.photo = dispalyModel.image
                }
               
            })
        }
        
        return cell
    }
}

extension PhotoCollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space = insets.left + insets.right
        let availableWidth = self.collectionView.frame.width - space * 2
        let widthPerItem = (Int)(availableWidth / 3)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let num = model?.getCountOfRows() {
            if indexPath.item == num - 5 {
                loadImages()
            }
        }
        
    }
    

    
}
