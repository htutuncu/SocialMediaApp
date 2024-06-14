//
//  UploadVC.swift
//  SocialMediaApp
//
//  Created by Hikmet Tütüncü on 14.06.2024.
//

import UIKit
import FirebaseCore
import FirebaseStorage

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func chooseImage() {
        let pc = UIImagePickerController()
        pc.delegate = self
        pc.sourceType = .photoLibrary
        present(pc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtn(_ sender: Any) {
        let storage = Storage.storage()
        let referance = storage.reference()
        
        let mediaFolder = referance.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let imgReference = mediaFolder.child("image.jpg")
            imgReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "Error upload.")
                } else {
                    imgReference.downloadURL { url, error in
                        if error == nil {
                            let imgUrl = url?.absoluteString
                            print(imgUrl)
                        }
                    }
                }
            }
        }
    }
}
