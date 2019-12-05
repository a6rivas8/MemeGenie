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


class UploadMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    let picker = UIImagePickerController()
    let db = Firestore.firestore()
    
    @IBOutlet weak var uploadMemeButton: UIButton!
    @IBOutlet weak var addMemeLabel: UILabel!
    @IBOutlet weak var tagsButton: UIButton!
    
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadImageCaption: UITextField!
    
    @IBOutlet weak var uploadImageProgress: UIProgressView!
    
    var defaultImage = UIImage(named: "blank")
    
    @IBOutlet weak var clearImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         uploadImageCaption.delegate = self
         self.hideKeyboardWhenTappedAround()
        CustomButton.styleButton(clearImageButton)
        
        /* Hide some stuff initially */
        uploadImageProgress.isHidden = true
        uploadImageCaption.isHidden = true
        tagsButton.isHidden = true
        clearImageButton.isHidden = true
        
        uploadImageView.layer.borderColor = UIColor.black.cgColor
        uploadImageView.layer.borderWidth = 2
        
        // Do any additional setup after loading the view.
        uploadImageView.image = defaultImage
        
        uploadImageProgress.setProgress(0, animated: false)
        
        picker.delegate = self
    
    // listen for keyboard
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
             NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
             
         }
         
        
         
         deinit {
             //Stop listening for keyboard hide/show events
             NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
             NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
             NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
         
     }
     // hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) ->
                Bool{
                  textField.resignFirstResponder()
                 return true
            }
            
     
     func hideKeyboard(){
        uploadImageCaption.resignFirstResponder()
         
     }
    // PRESSING RETURN WILL HIDE KEYBOARD
    func textFieldShouldReturn(uploadImageCaption: UITextField) -> Bool {

         uploadImageCaption.resignFirstResponder()
         return true
     }
     
     @objc func keyboardWillChange(notification: Notification){
        
        view.frame.origin.y = -180
        if notification.name.rawValue == "UIKeyboardWillHideNotification" {
            view.frame.origin.y = 0
        }
     }
    
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        uploadImageView.image = selectedImage
        /* Un-hide views */
        uploadImageCaption.isHidden = false
        uploadImageProgress.isHidden = false
        tagsButton.isHidden = false
        clearImageButton.isHidden = false
        
        /* Hide upload button and "Add Meme" label */
        uploadMemeButton.isHidden = true
        addMemeLabel.isHidden = true
        
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func selectPhotoForMeme(_ sender: Any) {
        let actionAlert = UIAlertController(title: "Upload", message: "Choose one", preferredStyle: .actionSheet)
        // To open camara but we are only using gallerry
        
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
        hideKeyboard()
    }
    
    @IBAction func uploadMeme(_ sender: Any) {
        let user = Auth.auth().currentUser
        let uid = user!.uid
       
        if uploadImageView.image != defaultImage && uploadImageCaption.text != "" {
            
            uploadImageProgress.isHidden = false
            
            let randomID = UUID.init().uuidString
            let uploadRef = Storage.storage().reference(withPath: "memes/\(randomID).jpg")
            guard let imageData = uploadImageView.image?.jpegData(compressionQuality: 0.75) else { return }
            
            let uploadMetaData = StorageMetadata.init()
            uploadMetaData.contentType = "image/jpeg"
            
            let taskReference = uploadRef.putData(imageData, metadata: uploadMetaData) { (downloadMetadata, error) in
                if let error = error {
                    print("Error uploading! \(error.localizedDescription)")
                    return
                }
                print("Put is complete & I got this back: \(String(describing: downloadMetadata))")
                
                uploadRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print("Got an error generating the URL: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    print("Here is your download URL: \(url.absoluteString)")
                    print("Date/Time posted: \(String(describing: downloadMetadata?.timeCreated))")
                    
                    // Create meme reference in Firestore database
                    // TODO: Tags for memes
                    self.db.collection("memes").document(randomID).setData([
                        "caption": self.uploadImageCaption.text!,
                        "date_uploaded": downloadMetadata?.timeCreated! ?? Timestamp(date: Date()),
                        "likes": 0,
                        "passes": 0,
                        "posted_by": uid,
                        "rank": 0,
                        "liked_by": [],
                        "passed_by": [],
                        "memeID": randomID,
                        "download_url": url.absoluteString
                    ]) { err in
                        if let err = err {
                            print("Error writing meme document: \(err.localizedDescription)")
                        } else {
                            print("Document meme succesfully written")
                            // reference meme to user
                            let alert = UIAlertController(title: "SUCCESS", message: "Meme uploaded succesfully", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            /* reset current imageview */
                            self.resetScreen()
                            
                        }
                    }
                }
            })
        }
            //progress bar
            taskReference.observe(.progress) { [weak self] (Snapshot) in
                            guard let pctThere = Snapshot.progress?.fractionCompleted else { return }
                            print("you are \(pctThere) complete")
                            self?.uploadImageProgress.progress = Float(pctThere)
                     }
            
        } else {
            let alert = UIAlertController(title: "Missing Fields", message: "Make sure image is selected and caption and tag fields are filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        hideKeyboard()
    }
    
    @IBAction func clearImage(_ sender: Any) {
        hideKeyboard()
        resetScreen()
    }
    
    func resetScreen(){
        uploadImageView.image = defaultImage
        /* Un-Hide upload button and "Add Meme" label */
        uploadMemeButton.isHidden = false
        addMemeLabel.isHidden = false
        
        /* Re-hide views */
        uploadImageCaption.isHidden = true
        uploadImageProgress.isHidden = true
        tagsButton.isHidden = true
        clearImageButton.isHidden = true
        
        uploadImageCaption.text = ""
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
