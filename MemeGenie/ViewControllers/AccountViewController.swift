//
//  AccountViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/15/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        changePasswordButton.layer.cornerRadius = 25
    }
    
    //Fist Name Text Box
    @IBAction func firstNameText(_ sender: UITextField) {
    }
    //First Name Label
    @IBOutlet weak var firstNameLabel: UILabel!
    
    //Last Name Text Box
    @IBAction func lastNameText(_ sender: UITextField) {
    }
    //Last Name Label
    @IBOutlet weak var lastNameLabel: UILabel!
    
    //User ID Text Box
    @IBAction func userIDText(_ sender: UITextField) {
    }
    //User ID Label
    @IBOutlet weak var userIDLabel: UILabel!
    
    //email Text Box
    @IBAction func emailText(_ sender: UITextField) {
    }
    //email Label
    @IBOutlet weak var emailLabel: UILabel!
    
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
