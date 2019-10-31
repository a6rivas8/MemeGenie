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

class UploadMemeViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let memeTags = ["Sad", "Happy","love","angry"]

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    let db = Firestore.firestore()
    let picker = UIImagePickerController()

     var defaultImage = UIImage(named: "noimage")
     var tag = ""
     
    
    @IBOutlet weak var tagLabel: UILabel!
    override func viewDidLoad(){
    super.viewDidLoad()
    progressView.isHidden = true
    picker.delegate = self
        
          }
          
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
        guard let selectedImage = info[.originalImage] as? UIImage else {
                 fatalError("Expected an image, but was provided the following: \(info)")
             }
             
             // Set photoImageView to display the selected image
             imageView.image = selectedImage
             defaultImage = selectedImage
        
          self.dismiss(animated: true, completion: nil)
      }

    
    @IBAction func addMeme(_ sender: Any) {
        progressView.isHidden = true
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.allowsEditing=false
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func ChooseTags(_ sender: Any) {
 
            
            let actionSheetAlert = UIAlertController(title: "Choose a tag ", message: "", preferredStyle: .actionSheet)
        for tags in memeTags { actionSheetAlert.addAction(UIAlertAction(title: tags, style: .default, handler: { _ in
            self.tagLabel.text = tags
            self.tag += tags
       
                   }))
            }
            actionSheetAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(actionSheetAlert, animated: true, completion: nil)
        
    
    }
    
    @IBAction func uploadImg(_ sender: Any) {
        if imageView.image == defaultImage {
        
        progressView.isHidden = false
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "memes/\(randomID).jpg")
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.075) else { return }
            
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
      let taskReference = uploadRef.putData(imageData, metadata: uploadMetadata) {(downloadMetadata, error) in
            if let error = error {
                print("Error uploading the meme! \(error.localizedDescription)")
                return
            }
            print(" completion and this is what we got back:  \(String(describing: downloadMetadata))")
   
        
            // Create meme reference in Firestore database
                       self.db.collection("memes").document(randomID).setData([
                        "tags": self.tag,
                           "date_uploaded": downloadMetadata?.timeCreated! ?? Timestamp(date: Date()),
                           "likes": 0,
                           "passes": 0,
                           "rank": 0,
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
        }               }
        
            taskReference.observe(.progress) { [weak self] (Snapshot) in
                   guard let pctThere = Snapshot.progress?.fractionCompleted else { return }
                   print("you are \(pctThere) complete")
                   self?.progressView.progress = Float(pctThere)
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
