//
//  UITextFieldExtensions.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-11-18.
//  Copyright © 2018 Filip Matić. All rights reserved.
//
//  Extensions to the UITextField class delivering custom functionalities and appearances. 

import UIKit

extension UITextField {
    func setupTextFieldAppearance(masksToBounds: Bool = false, cornerRadius: CGFloat = 4.0, borderWidth: CGFloat = 1.0, borderColor: CGColor? = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) {
        layer.masksToBounds = masksToBounds
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
    }
    
    func shake(horizontally: CGFloat = 0, vertically: CGFloat = 0) {
        let animation = CABasicAnimation(keyPath: "shake")
        animation.duration = 0.05
        animation.repeatCount = 5.0
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - horizontally, y: center.y - horizontally))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + horizontally, y: center.y + horizontally))
        
        self.layer.add(animation, forKey: "shake")
    }
    
    func showTextfieldError(borderColor: CGColor? = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)) {
        layer.borderColor = borderColor
        layoutIfNeeded()
    }
    
    func checkIfErrorColor(errorColor: CGColor? = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)) -> Bool {
        if layer.borderColor == errorColor {
            return true
        } else {
            return false
        }
    }
    
    func setValidBorderColor(borderColor: CGColor? = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) {
        layer.borderColor = borderColor
        layoutIfNeeded()
    }
    
    func setErrorBorderColor(borderColor: CGColor? = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)) {
        layer.borderColor = borderColor
        layoutIfNeeded()
    }
}
