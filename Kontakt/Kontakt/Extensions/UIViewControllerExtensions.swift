//
//  UIViewControllerExtensions.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-11-08.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

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
