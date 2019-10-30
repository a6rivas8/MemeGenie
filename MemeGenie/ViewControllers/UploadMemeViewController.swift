//
//  UploadMemeViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/15/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit
import Firebase

class UploadMemeViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let memeTags = ["Sad", "Happy","love","angry"]
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
           
    
     var originalImage = UIImage(named: "noimage")
    
     let picker = UIImagePickerController()
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
                 originalImage = selectedImage
            
              self.dismiss(animated: true, completion: nil)
          }

    
    @IBAction func uploadMeme(_ sender: Any) {
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
                   }))
            }
            actionSheetAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(actionSheetAlert, animated: true, completion: nil)
        
    
    }
    
    @IBAction func uploadImg(_ sender: Any) {
        progressView.isHidden = false
        let ramdomID = UUID.init().uuidString
        let uploadRef = Storage.storage().reference(withPath: "memes/\(ramdomID).jpg")
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
      let taskReference = uploadRef.putData(imageData, metadata: uploadMetadata) {(downloadMetadata, error) in
            if let error = error {
                print("Error uploading the meme! \(error.localizedDescription)")
                return
            }
            print(" completion and this is what we got back:  \(String(describing: downloadMetadata))")
    }
        taskReference.observe(.progress) { [weak self] (Snapshot) in
            guard let pctThere = Snapshot.progress?.fractionCompleted else { return }
            print("you are \(pctThere) complete")
            self?.progressView.progress = Float(pctThere)
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
