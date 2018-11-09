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
    
    lazy private var homeViewController = StoryboardScene.Main.homeViewController.instantiate()
    lazy private var infoViewController = StoryboardScene.Main.infoViewController.instantiate()
    lazy private var scannerViewController = StoryboardScene.Main.scannerViewController.instantiate()
    
    func start() {
        homeViewController.homeDelegate = self
        presentingViewController?.presentOrPush(homeViewController)
    }
}

extension KontaktCoordinator: HomeCoordinationDelegate {
    func homeDidFinishSuccessfully(_ success: Bool) {
        
    }
}

extension KontaktCoordinator: InfoCoordinationDelegate {
    func infoDidFinishSuccessfully(_ success: Bool) {
        
    }
}

extension KontaktCoordinator: ScannerCoordinationDelegate {
    func scannerDidFinishSuccessfully(_ success: Bool) {
        
    }
}
