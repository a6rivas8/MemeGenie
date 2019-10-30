//
//  UploadMemeViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/15/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit

class UploadMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let picker = UIImagePickerController()
    
    @IBOutlet weak var uploadImageView: UIImageView!
    @IBOutlet weak var uploadImageCaption: UITextField!
    @IBOutlet weak var uploadImageTags: UITextField!
    @IBOutlet weak var uploadImageProgress: UIProgressView!
    
    var defaultImage = UIImage(named: "noImage.jpeg")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        picker.delegate = self
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
