//
//  Coordinator.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-11-05.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get }
    var presentingViewController: UIViewController? { get }
    func start()
}
