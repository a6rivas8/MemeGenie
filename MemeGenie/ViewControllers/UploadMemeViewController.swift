//
//  UploadMemeViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/15/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UploadMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let picker = UIImagePickerController()
    let db = Firestore.firestore()
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadImageCaption: UITextField!
    @IBOutlet weak var uploadImageTags: UITextField!
    @IBOutlet weak var uploadImageProgress: UIProgressView!
    
    var defaultImage = UIImage(named: "noImage.jpeg")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uploadImageView.image = defaultImage
        picker.delegate = self
        
        let user = Auth.auth().currentUser
        //print(user?.metadata)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        uploadImageView.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectPhotoForMeme(_ sender: Any) {
        let actionAlert = UIAlertController(title: "Picker", message: "Choose one", preferredStyle: .actionSheet)
        actionAlert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: {_ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.sourceType = .camera
                self.picker.cameraCaptureMode = .photo
                self.present(self.picker, animated: true, completion: nil)
            } else {
                // let user know camera is not available
                print("Camera is not avail")
                let alert = UIAlertController(title: "No Camera", message: "No camera was found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in self.dismiss(animated: true, completion: nil)}))
                self.present(alert, animated: true, completion: nil)
            }
        }))
        actionAlert.addAction(UIAlertAction(title: "Open Gallery", style: .default, handler: {_ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
            } else {
                // could not present gallery
                print("Gallery is not avail")
                let alert = UIAlertController(title: "No Gallery", message: "No gallery was found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in self.dismiss(animated: true, completion: nil)}))
                self.present(alert, animated: true, completion: nil)
            }
            
        }))
        actionAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func uploadMeme(_ sender: Any) {
        if uploadImageView.image != defaultImage && uploadImageCaption.text != "" && uploadImageTags.text != "" {
            let randomID = UUID.init().uuidString
            let uploadRef = Storage.storage().reference(withPath: "memes/\(randomID).jpg")
            guard let imageData = uploadImageView.image?.jpegData(compressionQuality: 0.75) else { return }
            
            let uploadMetaData = StorageMetadata.init()
            uploadMetaData.contentType = "image/jpeg"
            
            uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetadata, error) in
                if let error = error {
                    print("Error uploading! \(error.localizedDescription)")
                    return
                }
                print("Put is complete & I got this back: \(String(describing: downloadMetadata))")
                // Create meme reference in Firestore database
                self.db.collection("memes").document(randomID).setData([
                    "caption": self.uploadImageCaption.text!,
                    "date_uploaded": downloadMetadata?.timeCreated! ?? Timestamp(date: Date()),
                    "likes": 0,
                    "passes": 0,
                    "rank": 0,
                    "tags": [self.uploadImageTags.text!]
                ]) { err in
                    if let err = err {
                        print("Error writing meme document: \(err.localizedDescription)")
                    } else {
                        print("Document meme succesfully written")
                        // reference meme to user
                        
                        
                        let alert = UIAlertController(title: "Noice", message: "Meme uploaded succesfully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Missing Fields", message: "Make sure image is selected and caption and tag fields are filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}