//
//  CustomButton.swift
//  MemeGenie
//
//  Created by Team6 on 10/11/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import UIKit

class CustomButton {
    static func styleButton(_ button:UIButton) {
        //setShadow(button)
        button.setTitleColor(.systemYellow, for: .normal)
        
        button.backgroundColor = UIColor.black
        button.titleLabel?.font = UIFont(name: "Calibri", size: 17)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private static func setShadow(_ button: UIButton) {
        button.layer.shadowColor = UIColor.yellow.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5
        button.clipsToBounds = true
        button.layer.masksToBounds = false
    }
}
