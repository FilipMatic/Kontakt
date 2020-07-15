//
//  UIViewControllerExtensions.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-11-08.
//  Copyright © 2018 Filip Matić. All rights reserved.
//
//  Extension to the UIViewController which determines if a viewController is to be
//  pushed onto the stack allowing the user to easily return to the previous view
//  or presented modally which requires the user to interact with the presented view.

import UIKit

extension UIViewController {
    func presentOrPush(_ viewController: UIViewController) {
        if let navigationController = self as? UINavigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
