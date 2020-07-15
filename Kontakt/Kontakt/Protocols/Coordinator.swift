//
//  Coordinator.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-11-05.
//  Copyright © 2018 Filip Matić. All rights reserved.
//
//  The coordinator pattern is used to dictate the flow of the app.
//  It is a lightweight pattern that handles navigation of an app in a scalable way.

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var presentingViewController: UIViewController? { get }
    func start() // Function will be implemented by classes adopting the pattern
}
