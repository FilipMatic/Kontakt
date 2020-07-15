//
//  UIViewExtensions.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-12-14.
//  Copyright © 2018 Filip Matić. All rights reserved.
//
//  Extension to the UIView class customizing appearance.

import Foundation
import UIKit

extension UIView {
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradient.locations = [0.0, 1.0]
//        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
//        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradient, at: 0)
    }
}
