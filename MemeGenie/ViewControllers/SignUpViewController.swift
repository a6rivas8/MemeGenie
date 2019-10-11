//
//  SignUpViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/10/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!
    @IBOutlet weak var signUpTextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        // hide error label
        errorTextField.alpha = 0
        
        // style elements
        CustomTextField.styleTextField(fullNameTextField)
        CustomTextField.styleTextField(userIDTextField)
        CustomTextField.styleTextField(emailTextField)
        CustomTextField.styleTextField(passwordTextField)
        CustomTextField.styleTextField(confirmPasswordTextField)
        
        CustomButton.styleButton(signUpTextButton)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
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
