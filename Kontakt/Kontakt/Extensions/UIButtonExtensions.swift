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
    ///   - cornerRadius: Default is 29.0
    ///   - image: Default is nil
    ///   - borderWidth: Default is 1.0
    ///   - borderColor: Defauly is white
    func setupButtonAppearance(masksToBounds: Bool = false, cornerRadius: CGFloat = 29.0, image: UIImage? = nil, borderWidth: CGFloat = 1.0, borderColor: CGColor? = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) {
        layer.masksToBounds = masksToBounds
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor
        if let buttonImage = image {
            setImage(buttonImage, for: .normal)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
            contentHorizontalAlignment = .left
        }
    }
}
