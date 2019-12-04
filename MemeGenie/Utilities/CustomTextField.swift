//
//  CustomTextField.swift
//  MemeGenie
//
//  Created by Team6 on 10/11/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit

class CustomTextField {
    static func styleTextField(_ textfield:UITextField) {
        let bottomLine = CALayer()
        
        textfield.borderStyle = .none
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width-20, height: 2)
        bottomLine.backgroundColor = UIColor.black.cgColor
        
        textfield.layer.addSublayer(bottomLine)
    }
}
