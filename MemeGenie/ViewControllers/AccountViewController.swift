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
    @IBOutlet weak var newPasswordText: UITextField!
    //Confirm Password Text
    @IBOutlet weak var confirmPasswordText: UITextField!
    
    //Confirmation Label
    @IBOutlet weak var confirmationLabel: UILabel!
    
    //Error Label
    @IBOutlet weak var errorLabel: UILabel!
    
    //Save Button
    @IBOutlet weak var saveButton: UIButton!
    
    //View memes user has posted (button)
    @IBOutlet weak var viewMemesPosted: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        
        //Button radius
        //saveNewPassword.layer.cornerRadius = 25
        
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
    
    func setUpElements() {
        // hide error label
        //errorTextField.alpha = 0
        
        // style elements
        CustomButton.styleButton(saveButton)
        CustomButton.styleButton(viewMemesPosted)
        CustomTextField.styleTextField(newPasswordText)
        CustomTextField.styleTextField(confirmPasswordText)
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
    
    //Sign Out Button
    @IBAction func signOutButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Log Current User Out?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: {action in
            
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.transitionToViewController()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }))
        alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
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
    
    // transition to login/sign up screen
    func transitionToViewController() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "LoginSignUp") as? ViewController
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
        
        /*var rootVC : UIViewController?
        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginSignUp") as! ViewController
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         appDelegate.window?.rootViewController = rootVC*/
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
