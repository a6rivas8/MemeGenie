//
//  CardView.swift
//  MemeGenie
//
//  Created by Team 6 on 11/22/19.
//  Copyright © 2019 Team6. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CardView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.yellow
    @IBInspectable let shadowOffSetWidth: Int = 0
    @IBInspectable let shadowOffSetHeight: Int = 1
    
    @IBInspectable let shadowOpacity: Float = 0.75
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = shadowOpacity
        
    }
    
}
