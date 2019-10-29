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
    
    //Meme
    @IBOutlet weak var meme: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setUpElements()
        
        //Set User Info in Labels
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
           
        if let user = user {
            let uid = user.uid
            
            db.collection("users").whereField("uid", isEqualTo: uid).getDocuments(){(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                } else {
                    let document = querySnapshot!.documents[0]
                    
                    let memeText = document.get("memes_posted")
                    
                    self.meme.text = " "+(memeText as! String);
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
