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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Button radius
        changePasswordButton.layer.cornerRadius = 25
        
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
                    
                    self.firstNameText.text = " "+(firstname as! String);
                    self.lastNameText.text = " "+(lastname as! String);
                    self.emailText.text = " "+(email!);
                }
            }
        }
    }
    
    //First Name Label
    @IBOutlet weak var firstNameLabel: UILabel!
    //First Name Info
    @IBOutlet weak var firstNameText: UILabel!
    
    //Last Name Label
    @IBOutlet weak var lastNameLabel: UILabel!
    //Last Name Info
    @IBOutlet weak var lastNameText: UILabel!
    
    //email Label
    @IBOutlet weak var emailLabel: UILabel!
    //email Info
    @IBOutlet weak var emailText: UILabel!
    
    //Change Password Label
    @IBOutlet weak var changePasswordLabel: UILabel!
    //New Password Text
    @IBAction func newPasswordText(_ sender: UITextField) {
    }
    //Confirm Password Text
    @IBAction func confirmPasswordText(_ sender: UITextField) {
    }
    //Change Password (Save) Button
    @IBOutlet weak var changePasswordButton: UIButton!

    //Sign Out Button
    @IBAction func signOutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.transitionToViewController()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // transition to login/sign up screen
    func transitionToViewController() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "LoginSignUp") as? ViewController
            view.window?.rootViewController = viewController
            view.window?.makeKeyAndVisible()
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
