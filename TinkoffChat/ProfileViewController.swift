//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 20.09.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var nameLablel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var chooseIconButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    //MARK: -
    var picker:UIImagePickerController?=UIImagePickerController()
    
    //MARK: - Lifecicle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //print("init \(editButton.frame)") //Ничего не выведется в консоль, так как метод не вызывается
                                            //Так как ViewController создан в Storyboard
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        print("init \(editButton.frame)") //Crash так как пытаемся обратиться к несуществующему объекту
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() // Always
        logInfo()
        print("\(editButton.frame)")
    
        picker?.delegate = self
        
        chooseIconButton.layer.cornerRadius = chooseIconButton.frame.height/2.0
        iconImgView.layer.cornerRadius = chooseIconButton.layer.cornerRadius
        
        editButton.layer.borderWidth = 2.0
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.cornerRadius = 15.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)  // Always
        logInfo()
        print("\(editButton.frame)")    //Не отличается от значения во viewDidLoad, так как мы все еще не известны
                                        //реальные размеры экрана и элементы не перестроились под него
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)   // Always
        logInfo()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()  //Not neccessary
        logInfo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()   //Not neccessary
        logInfo()
        print("\(editButton.frame)")
    }
    
    override func  viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated) // Always
        logInfo()
    }
    override func  viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated) // Always
        logInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() // Always
//      automated log
    }

    // MARK: - Logs
    
    private func logInfo (string: String = #function) {
        print("ViewConstoller method : \(string)")
    }
    
    // MARK: - Actions
    
    @IBAction func chooseIconAction(_ sender: UIButton) {
        print("Выбери изображение профиля»")
        
        let alertController = UIAlertController(title: nil, message: "Откуда выбрать изображение?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { action in
        }
        alertController.addAction(cancelAction)
        
        let galleryAction = UIAlertAction(title: "Установить из галлереи", style: .default) { action in
            self.openGallary()
        }
        alertController.addAction(galleryAction)
        
        let photoAction = UIAlertAction(title: "Сделать фото", style: .default) { action in
            self.openCamera()
        }
        alertController.addAction(photoAction)
        
        self.present(alertController, animated: true) {
        }
    }
    
    @IBAction func editAction(_ sender: Any) {
    }
    
    //MARK: - Choose Photo Func
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker!.allowsEditing = false
            picker!.sourceType = .photoLibrary
            present(picker!, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker!.allowsEditing = false
            picker!.sourceType = .camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Внимание", message: "На данном девайсе нет камеры", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - imagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.image = choosenImage
        dismiss(animated: true, completion: nil)
    }

}

