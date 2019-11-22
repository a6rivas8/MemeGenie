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
                    
                    self.nameText.text = " "+(firstname as! String)+" "+(lastname as! String);
                    //self.lastNameText.text = " "+(lastname as! String);
                    self.emailText.text = " "+(email!);
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
        
        //CustomTextField.styleTextField(nameText)
        nameText.font = UIFont.boldSystemFont(ofSize: 25)
        //userActivityLabel.font = UIFont.boldSystemFont(ofSize: 18)

        //CustomTextField.styleTextField(emailText)
        //CustomTextField.styleTextField(newPasswordText)
        //CustomTextField.styleTextField(confirmPasswordText)
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
