//
//  LoginViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/10/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!
    @IBOutlet weak var loginTextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        // Hide error label
        errorTextField.alpha = 0
        
        // Style elements
        CustomTextField.styleTextField(emailTextField)
        CustomTextField.styleTextField(passwordTextField)
        
        CustomButton.styleButton(loginTextButton)
    }
    func textFieldShouldReturn(_ textField: UITextField) ->
                Bool{
                  textField.resignFirstResponder()
                 return true
            }
            
    func validateFields() -> String? {
        // Check all fields are not empty
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        // Check if email is valid
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if credentialValidator.isEmailValid(cleanedEmail) == false {
            return "Please enter valid email address."
        }

        return nil
    }
    
    @IBAction func loginButton(_ sender: Any) {
        // Validate Fields
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            // Signing user in
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "Some Error")
                    self.showError("Error Signing In.")
                } else {
                    self.transitionToHome()
                }
            }
        }
    }
    
    func showError(_ message:String) {
        errorTextField.text = message
        errorTextField.alpha = 1
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}
