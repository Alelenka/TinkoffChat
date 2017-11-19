//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 20.09.17.
//  Copyright © 2017 AB. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIPopoverControllerDelegate {

    //MARK: - Outlets
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var chooseIconButton: UIButton!
//    @IBOutlet weak var gcdButton: UIButton!
//    @IBOutlet weak var operationButton: UIButton!
    @IBOutlet weak var coreDataBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    
    var model: IProfileModel?
    //MARK: -
    
    private var picker: UIImagePickerController = UIImagePickerController()
    private var currentProfile: ProfileDisplayModel = ProfileDisplayModel.defaultProfile() {
        didSet {
            model?.update(profile: currentProfile)
            if let changed = model?.profileChanged {
                deactivateUI(!changed)
            }
        }
    }
    
    //MARK: - Lifecicle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() // Always
        
        nameTextField.delegate = self
        descriptionTextField.delegate = self
        picker.delegate = self
        prepareUI()
        
        model?.load(managerType: .coreData, completionHandler: { [weak self] (profile) in
            if let strongSelf = self {
                strongSelf.currentProfile = profile
                strongSelf.updateUI()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)  // Always
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func  viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated) // Always
//        logInfo()
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning() // Always
//      automated log
    }

    // MARK: - UI
    private func prepareUI() {
        iconImgView.image = nil
        chooseIconButton.layer.cornerRadius = chooseIconButton.frame.height/2.0
        iconImgView.layer.cornerRadius = chooseIconButton.layer.cornerRadius
    
        //        prepare(button: editButton)
//        prepare(button: gcdButton)
//        prepare(button: operationButton)
        prepare(button: coreDataBtn)
    
        deactivateUI(true)
    }
    
    private func prepare(button: UIButton) {
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15.0
    }
    
    private func deactivateUI(_ deactivate: Bool){
//        operationButton.isEnabled = !deactivate
//        gcdButton.isEnabled = !deactivate
        coreDataBtn.isEnabled = !deactivate
    }
    
    private func updateUI() {
        nameTextField.text = currentProfile.name
        descriptionTextField.text = currentProfile.info
        iconImgView.image = currentProfile.photo
        activityIndicator.stopAnimating()
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
        
        let downloadAction = UIAlertAction(title: "Загрузить", style: .default) { action in
            self.openCollection()
        }
        alertController.addAction(downloadAction)
        
        self.present(alertController, animated: true) {
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
//    @IBAction func gcdButtonAction(_ sender: Any) {
//        saveProfile(managerType: .GCD)
//    }
//    
//    @IBAction func operationButtonAction(_ sender: Any) {
//        saveProfile(managerType: .operationQueue)
//    }
    
    @IBAction func coreDataButtinAction(_ sender: Any) {
        saveProfile(managerType: .coreData)
    }
    
    // MARK: - Save
    func saveProfile(managerType: ProfileManagerType) {//<T: SaveInfoProtocol>(manager: T) {
        if let changed = model?.profileChanged, changed {
            activityIndicator.startAnimating()
            deactivateUI(true)
            model?.save(managerType: managerType, completionHandler: { [weak self] (success) in
                if let strongSelf = self {
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.deactivateUI(false)
                    if success {
                        strongSelf.showOkAlert(with: "Данные сохранены", message: "")
                    } else {
                        strongSelf.saveErrorAlert(withh: managerType)
                    }

                }
            })
        }
    }
    
    private func saveErrorAlert(withh managerType: ProfileManagerType) {
        let alert = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
        let action = UIAlertAction(title: "Повторить", style:.default, handler: { _ in
            self.saveProfile(managerType: managerType)
        })
        
        alert.addAction(ok)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Choose Photo Func
    
    func openGallary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            present(picker, animated: true, completion: nil)
        }else{
            showOkAlert(with: "Внимание", message: "На данном девайсе нет камеры")
        }
    }
    
    func openCollection() {
        guard let photoCollectionVC = UIStoryboard(name: "PhotoCollection", bundle: nil).instantiateInitialViewController() as? PhotoCollectionController else {
            return
        }
        photoCollectionVC.delegate = self
        
        PhotoCollectionAssembly().setup(inViewController: photoCollectionVC)
        
        self.present(photoCollectionVC, animated: true, completion: nil)
    }
}

    // MARK: - keyboard
extension ProfileViewController {
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrame.origin.y >= UIScreen.main.bounds.size.height {
                self.contentTopConstraint?.constant = 0.0
            } else {
                self.contentTopConstraint?.constant = -endFrame.size.height/2.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

    // MARK: - imagePickerController
extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let choosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        currentProfile.photo = choosenImage
        iconImgView.image = choosenImage
        dismiss(animated: true, completion: nil)
    }
}

    // MARK: - UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if (textField == nameTextField){
            currentProfile.name = textField.text!
        } else if (textField == descriptionTextField){
            currentProfile.info = textField.text!
        }
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == nameTextField){
            currentProfile.name = textField.text!
        } else if (textField == descriptionTextField){
            currentProfile.info = textField.text!
        }
    }
}

extension ProfileViewController: PhotoCollectionControllerDelegate {
    
    func photoCollectionController(_ photoCollectionController: PhotoCollectionController, didFinishPickingImage image: UIImage) {
        currentProfile.photo = image
        iconImgView.image = image
    }
}

