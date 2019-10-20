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
        self.firstNameText.text = firstName;
        self.lastNameText.text = lastName;
        self.userIDText.text = userID;
        self.emailText.text = email;
        self.phoneText.text = phone;
    }
    
    //User Info
    let userID = Auth.auth().currentUser?.uid
    let firstName = Auth.auth().currentUser?.displayName
    let lastName = Auth.auth().currentUser?.displayName
    let email = Auth.auth().currentUser?.email
    let phone = Auth.auth().currentUser?.phoneNumber
    
    //First Name Label
    @IBOutlet weak var firstNameLabel: UILabel!
    //First Name Info
    @IBOutlet weak var firstNameText: UILabel!
    
    //Last Name Label
    @IBOutlet weak var lastNameLabel: UILabel!
    //Last Name Info
    @IBOutlet weak var lastNameText: UILabel!
    
    //User ID Label
    @IBOutlet weak var userIDLabel: UILabel!
    //User ID Info
    @IBOutlet weak var userIDText: UILabel!
    
    //email Label
    @IBOutlet weak var emailLabel: UILabel!
    //email Info
    @IBOutlet weak var emailText: UILabel!
    
    //phone Label
    @IBOutlet weak var phoneLabel: UILabel!
    //phone Info
    @IBOutlet weak var phoneText: UILabel!
    
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

    //Sign Out Icon
    @IBOutlet weak var signOutIcon: UIImageView!
    //Sign Out Button
    @IBAction func signOutButton(_ sender: UIButton) {
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
