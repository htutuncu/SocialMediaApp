//
//  UploadVC.swift
//  SocialMediaApp
//
//  Created by Hikmet Tütüncü on 14.06.2024.
//

import UIKit
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

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
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func postBtn(_ sender: Any) {
        let storage = Storage.storage()
        let referance = storage.reference()
        
        let mediaFolder = referance.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imgReference = mediaFolder.child("img\(uuid).jpg")
            imgReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    imgReference.downloadURL { url, error in
                        if error == nil {
                            let imgUrl = url?.absoluteString
                            
                            // Save to database.
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imgUrl": imgUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postDescription" : self.postTextField.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String: Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    self.goToHomePageAndReset()
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func goToHomePageAndReset() {
        self.imageView.image = UIImage(named: "selectimage")
        self.postTextField.text = ""
        self.tabBarController?.selectedIndex = 0
    }
}
