//
//  ChangePasswordViewController.swift
//  MemeGenie
//
//  Created by Derrick Ellis on 11/10/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class ChangePasswordViewController: UIViewController, UITextFieldDelegate{
    
    //New Password Text
    @IBOutlet weak var newPasswordText: UITextField!
    
    //Confirm Password Text
    @IBOutlet weak var confirmPasswordText: UITextField!
    
    //Confirmation Label
    @IBOutlet weak var confirmationLabel: UILabel!
    
    //Error Label
    @IBOutlet weak var errorLabel: UILabel!
    
    //ErrorCard
    @IBOutlet weak var errorView: UIView!
    
    //Save Button
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        
        let error = validateFields()
        showError(error!)
        
        errorView.layer.cornerRadius = 3
        errorView.layer.shadowColor = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0).cgColor
        errorView.layer.shadowOffset = CGSize(width: 0, height: 1.75)
        errorView.layer.shadowRadius = 1.7
        errorView.layer.shadowOpacity = 0.45
            
        //Set User Info in Labels
        let user = Auth.auth().currentUser
        let db = Firestore.firestore()
               
        if let user = user {
            let uid = user.uid
            //let email = user.email
                
            db.collection("users").whereField("uid", isEqualTo: uid).getDocuments(){(querySnapshot, err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                } else {
                    // nothing...
                }
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) ->
                Bool{
                  textField.resignFirstResponder()
                 return true
            }
            
        
    func setUpElements() {
         // nothing...
    }
        
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
        
    func showConfirmation(){
        confirmationLabel.text = "Your password has successfully been updated."
    }
        
    //Change Password (Save) Button
    @IBAction func saveNewPassword(_ sender: UIButton) {
        let error = validateFields()
            
        if error != nil {
            errorLabel.textColor = UIColor.red
            showError(error!)
            print("Error changing password!")
        } else{
            let user = Auth.auth().currentUser;
            let newPassword = newPasswordText.text!;

            //Clear error message (if there is one)
            errorLabel.text = ""
        
            //Update Password
            user?.updatePassword(to: newPassword)
            print("Password successfully updated.")
            showConfirmation()
        }
    }
        
    // Check the fields and validate that data is correct.
    // Returns nil if all is correct.
    // Returns error message else.
    func validateFields() -> String? {
        // Check if passwords match and are strong
        if newPasswordText.text! != confirmPasswordText.text! {
            return "*Please make sure passwords match."
        }
            
        let cleanedPassword = newPasswordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if credentialValidator.isPasswordValid(cleanedPassword) == false {
            return "*Please make sure your password is at least 8 characters and contains 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character."
        }
        return nil
    }
}
