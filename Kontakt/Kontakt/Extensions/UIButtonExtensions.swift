//
//  UIButtonExtensions.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-11-17.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit

extension UIButton {
    /// Setup button with inserted parameters. Leave empty to create default QuickTest button.
    ///
    /// - Parameters:
    ///   - masksToBounds: Default is false
    ///   - cornerRadius: Default is 10
    ///   - shadowColor: Default is black
    ///   - shadowOpacity: Default is 0.21
    ///   - shadowRadius: Default is 2
    ///   - shadowOffset: Default is width:2, height:2
    ///   - image: Default is nil
    func setupButtonAppearance(masksToBounds: Bool = false, cornerRadius: CGFloat = 10, shadowColor: UIColor = .black, shadowOpacity: Float = 0.21, shadowRadius: CGFloat = 2.0, shadowOffset: CGSize = CGSize(width: 2, height: 2), image: UIImage? = nil) {
        layer.masksToBounds = masksToBounds
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        if let buttonImage = image {
            setImage(buttonImage, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
            contentHorizontalAlignment = .left
        }
    }
}
