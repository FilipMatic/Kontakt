//
//  KontaktCoordinator.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-11-05.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit

final class KontaktCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var presentingViewController: UIViewController?
    
    lazy private var navigationController = StoryboardScene.Main.initialScene.instantiate()
    
    lazy private var homeViewController = StoryboardScene.Main.homeViewController.instantiate()
    lazy private var infoViewController = StoryboardScene.Main.infoViewController.instantiate()
    lazy private var scannerViewController = StoryboardScene.Main.scannerViewController.instantiate()
    
    lazy private var window = UIWindow()
    
    func start() {
//        homeViewController.homeDelegate = self
//        presentingViewController = homeViewController
//        presentingViewController?.presentOrPush(homeViewController)
        
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(homeViewController, animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension KontaktCoordinator: HomeCoordinationDelegate {
    func homeDidFinishSuccessfully(_ success: Bool) {
        if success {
            infoViewController.infoDelegate = self
            presentingViewController?.presentOrPush(infoViewController)
        } else {
            scannerViewController.scannerDelegate = self
            presentingViewController?.presentOrPush(scannerViewController)
        }
        
    }
}

extension KontaktCoordinator: InfoCoordinationDelegate {
    func infoDidFinishSuccessfully(_ success: Bool) {
        homeViewController.homeDelegate = self
        presentingViewController?.presentOrPush(homeViewController)
    }
}

extension KontaktCoordinator: ScannerCoordinationDelegate {
    func scannerDidFinishSuccessfully(_ success: Bool) {
        homeViewController.homeDelegate = self
        presentingViewController?.presentOrPush(homeViewController)
    }
}
