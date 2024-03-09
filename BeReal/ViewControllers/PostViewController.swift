//
//  PostViewController.swift
//  BeReal
//
//  Created by Mina on 3/4/24.
//

import UIKit
import PhotosUI
import ParseSwift


class PostViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var pickedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func presentCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    
    func presentPHPicker() {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1
        let PHPicker = PHPickerViewController(configuration: config)
        PHPicker.delegate = self
        present(PHPicker, animated: true)
    }
    
    
    @IBAction func photoLibraryButtonPressed(_ sender: Any) {
        
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == PHAuthorizationStatus.authorized {
            
            DispatchQueue.main.async { [weak self] in
                self?.presentPHPicker()
            }
            
        } else {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                
                switch status {
                case .notDetermined:
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.presentPHPicker()
                    }
                    
                case .denied:
                    let alert = AlertPresenter.alert(title: "Photo Access Required", message: "In order to post a photo to complete a task, we need access to your photo library. You can allow access in Settings", actions: [UIAlertAction(title: "Settings", style: .default, handler: { _ in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    })])
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.present(alert, animated: true)
                    }
                    
                case .authorized:
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.presentPHPicker()
                    }
                default:
                    break
                }
            }
        }
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        DispatchQueue.main.async { [weak self] in
            self?.presentCamera()
        }
    }
    
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        guard let image = pickedImage, let imageData = image.jpegData(compressionQuality: 0.1) else { return}

        let imageFile = ParseFile(name: "image.jpg", data: imageData)
        
        var post = Post()
        post.user = User.current
        post.description = captionTextField.text
        post.imageFile = imageFile
        
        post.save { [weak self] result in
            switch result {
                
            case .success(_):
                DispatchQueue.main.async {
                    self?.postImageView.image = UIImage(named: "photographer")
                    self?.captionTextField.text = nil
                    self?.view.endEditing(true)
                    self?.tabBarController?.selectedIndex = 0
                }
            case .failure(let error):
                
                DispatchQueue.main.async {
                    let alert = AlertPresenter.alert(title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "Try again", style: .cancel)])
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}


extension PostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {return}
        pickedImage = image
   
        DispatchQueue.main.async { [weak self] in
            self?.postImageView.image = image
        }
    }
}


extension PostViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let result = results.first
        
        guard let provider = result?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {return}
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            if let error {
                
                let alert = AlertPresenter.alert(title: "Error", message: error.localizedDescription, actions: [UIAlertAction(title: "Try again", style: .cancel)])
                
                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }
            }
            guard let image = object as? UIImage else { return }
            self?.pickedImage = image
            
            DispatchQueue.main.async {
                self?.postImageView.image = image
            }
        }
    }
}
