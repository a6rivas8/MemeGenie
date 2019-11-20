//
//  ViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/10/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit
import Canvas
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var memegenieView: CSAnimationView!
    @IBOutlet weak var pepeLeft: CSAnimationView!
    @IBOutlet weak var pepeRight: CSAnimationView!
    @IBOutlet weak var Logo: CSAnimationView!
    
    
    @IBOutlet weak var signUpTextButton: UIButton!
    @IBOutlet weak var loginTextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }

    func setUpElements() {
        // style elements
        CustomButton.styleButton(signUpTextButton)
        CustomButton.styleButton(loginTextButton)
    }
    
    @IBAction func pressed(_ sender: Any) {
        memegenieView.startCanvasAnimation()
        pepeLeft.startCanvasAnimation()
        pepeRight.startCanvasAnimation()
        Logo.startCanvasAnimation()
    }
}

