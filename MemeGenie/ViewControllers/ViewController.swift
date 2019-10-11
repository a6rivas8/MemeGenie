//
//  ViewController.swift
//  MemeGenie
//
//  Created by Team6 on 10/10/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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

}

