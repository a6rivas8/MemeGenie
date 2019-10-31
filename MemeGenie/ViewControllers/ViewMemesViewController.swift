//
//  AccountViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/29/19.
//  Copyright © 2019 Team6. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth

class ViewMemesViewController: UIViewController {
    
    //Meme Caption
    @IBOutlet weak var meme: UILabel!
    //Meme Image
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setUpElements()
        
        //Set User Info in Labels
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
           
        if let user = user {
            let uid = user.uid
            
            db.collection("memes").whereField("posted_by", isEqualTo: uid).getDocuments(){(querySnapshot, err) in
                if let err = err{
                    print("Error getting images: \(err)")
                } else {
                    let document = querySnapshot!.documents[0]
                    
                    let memeID = document.get("memeID")
                    let caption = document.get("caption")
                    
                    self.meme.text = memeID as? String
                    
                    
                    let storageRef = Storage.storage().reference(withPath: "memes/"+(memeID as! String)+".jpg")
                    storageRef.getData(maxSize: 4 * 1024 * 1024) {(data, error) in
                        if let error = error {
                            print("Got an error fetching image: \(error.localizedDescription)")
                            return
                        }
                        if let data = data {
                            self.memeImageView.image = UIImage(data: data)
                        }
                        }
                }
            }
    
        
    }
    
    func setUpElements() {
        // hide error label
        //errorTextField.alpha = 0
        
        // style elements
        //CustomButton.styleButton(saveButton)
        //CustomButton.styleButton(viewMemesPosted)
        //CustomTextField.styleTextField(newPasswordText)
        //CustomTextField.styleTextField(confirmPasswordText)
    }
}
}
