//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 20.09.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //MARK: - Outlets
    
    @IBOutlet weak var iconImgView: UIImageView!
//    @IBOutlet weak var nameLablel: UILabel!
//    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var chooseIconButton: UIButton!
//    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var gcdButton: UIButton!
    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    
    //MARK: -
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var currentProfile: ProfileData = ProfileData.init()
    
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
//        print("\(editButton.frame)")
        
        nameTextField.delegate = self
        descriptionTextField.delegate = self
    
        iconImgView.image = nil
        picker?.delegate = self
        
        chooseIconButton.layer.cornerRadius = chooseIconButton.frame.height/2.0
        iconImgView.layer.cornerRadius = chooseIconButton.layer.cornerRadius
        
//        prepare(button: editButton)
        prepare(button: gcdButton)
        prepare(button: operationButton)
        
        deactivateUI(false)
        
        GCDDataManader.init().readFile() {  [weak self] (result) in
            if let strongSelf = self {
                let profile = result ?? ProfileData.init()
                strongSelf.currentProfile = profile
//                strongSelf.nameLablel.text = profile.profileName
//                strongSelf.descriptionLabel.text = profile.profileDescription
                strongSelf.nameTextField.text = profile.profileName
                strongSelf.descriptionTextField.text = profile.profileDescription
                strongSelf.iconImgView.image = profile.profileImage
                strongSelf.activityIndicator.stopAnimating()
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)  // Always
        logInfo()
//        print("\(editButton.frame)")  //Не отличается от значения во viewDidLoad, так как мы все еще не известны
                                        //реальные размеры экрана и элементы не перестроились под него
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
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
    }
    
    override func  viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated) // Always
        logInfo()
        NotificationCenter.default.removeObserver(self)
    }
    override func  viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated) // Always
        logInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() // Always
//      automated log
    }

    // MARK: - UI
    
    func prepare(button: UIButton) {
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15.0
    }
    
    func deactivateUI(_ enabled: Bool){
        
        operationButton.isEnabled = enabled
        gcdButton.isEnabled = enabled
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
    
//    @IBAction func editAction(_ sender: Any) {
//    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func gcdButtonAction(_ sender: Any) {
        let gcdDataManager = GCDDataManader.init()
        saveProfile(manager: gcdDataManager)
    }
    
    @IBAction func operationButtonAction(_ sender: Any) {
        let operationDataManager = OperationDataManager.init()
        saveProfile(manager: operationDataManager)
    }
    
    
    // MARK: - Save
    
    func saveProfile<T: SaveInfoProtocol>(manager: T) {
        activityIndicator.startAnimating()
        deactivateUI(true)
        
        if currentProfile.changed {
            manager.save(profileData: currentProfile.getSavingData()) {  [weak self] (result) in
                if let strongSelf = self {
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.deactivateUI(false)
                    if result {
                        strongSelf.showOkAlert(with: "Данные сохранены", message: "")
                        strongSelf.currentProfile.changed = false
                    } else {
                        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
                        let action = UIAlertAction(title: "Повторить", style:.default, handler: { _ in
                            strongSelf.saveProfile(manager: manager)
                        })
                        
                        alert.addAction(ok)
                        alert.addAction(action)
                        
                        strongSelf.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
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
            showOkAlert(with: "Вниание", message: "На данном девайсе нет камеры")
        }
    }
    
    //MARK: - imagePickerController
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        if !currentProfile.isImageEqual(newImage: choosenImage){
            currentProfile.profileImage = choosenImage
            currentProfile.changed = true;
            deactivateUI(false)
        }
        
        iconImgView.image = choosenImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if (textField == nameTextField){
            if currentProfile.profileName != textField.text {
                currentProfile.profileName = textField.text!
                currentProfile.changed = true
            }
        } else if (textField == descriptionTextField){
            if currentProfile.profileDescription != textField.text {
                currentProfile.profileDescription = textField.text!
                currentProfile.changed = true
            }
        }
        
        deactivateUI(currentProfile.changed)
        
        return false
    }
    
    // MARK: - keyboard
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.contentTopConstraint?.constant = 0.0
            } else {
                if let keyboardHeignt = endFrame?.size.height {
                    self.contentTopConstraint?.constant = -keyboardHeignt/2.0
                }
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

}

