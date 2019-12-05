//
//  AccountViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/15/19.
//  Copyright © 2019 Team6. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth

class AccountViewController: UIViewController {
    
    //First Name
    @IBOutlet weak var nameText: UITextField!
    
    //email
    @IBOutlet weak var emailText: UITextField!
    
    //View memes user has posted (button)
    @IBOutlet weak var viewMemesPosted: UIButton!
    
    //
    @IBOutlet weak var viewMemesArrow: UIImageView!
    
    //
    @IBOutlet weak var changePasswordArrow: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        
        //Set User Info in Labels
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
           
        if let user = user {
            let uid = user.uid
            let email = user.email
            
            db.collection("users").whereField("uid", isEqualTo: uid).getDocuments(){(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                } else {
                    let document = querySnapshot!.documents[0]
                    
                    let firstname = document.get("first_name")
                    let lastname = document.get("last_name")
                    
                    self.nameText.text = " "+(firstname as! String)+" "+(lastname as! String);
                    self.emailText.text = " "+(email!);
                }
            }
        }
    }
    
    func setUpElements() {
        
        nameText.font = UIFont.boldSystemFont(ofSize: 25)
        
    }
        
    //Sign Out Button
    @IBAction func signOutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Log Out?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: {action in
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.transitionToViewController()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
        
    // transition to login/sign up screen
    func transitionToViewController() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "LoginSignUp") as? ViewController
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
        
    }
}
