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
    
    let navigationController: UINavigationController?
    
    lazy private var homeViewController = StoryboardScene.Main.homeViewController.instantiate()
    lazy private var infoViewController = StoryboardScene.Main.infoViewController.instantiate()
    lazy private var scannerViewController = StoryboardScene.Main.scannerViewController.instantiate()
    lazy private var onboardingViewController = StoryboardScene.Main.onboardingViewController.instantiate()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        navigationController?.isNavigationBarHidden = true
        
        if UserDefaults.standard.bool(forKey: "onboardingCompleted") {
            homeViewController.homeDelegate = self
            self.navigationController?.pushViewController(homeViewController, animated: false)
        } else {
            onboardingViewController.onboardingDelegate = self
            self.navigationController?.pushViewController(onboardingViewController, animated: false)
        }
    }
}

extension KontaktCoordinator: HomeCoordinationDelegate {
    func homeDidFinishSuccessfully(_ success: Bool) {
        if success {
            infoViewController.infoDelegate = self
            self.navigationController?.pushViewController(infoViewController, animated: true)
        } else {
            scannerViewController.scannerDelegate = self
            if (self.navigationController?.viewControllers.count)! > 1 {
                self.navigationController?.pushViewController(scannerViewController, animated: true)
            } else {
                self.navigationController?.pushViewController(scannerViewController, animated: true)
            }
        }
    }
}

extension KontaktCoordinator: InfoCoordinationDelegate {
    func infoDidFinishSuccessfully(_ success: Bool) {
        homeViewController.homeDelegate = self
        if success {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.pushViewController(homeViewController, animated: true)
            self.navigationController?.viewControllers = []
            self.navigationController?.pushViewController(homeViewController, animated: false)
        }
    }
}

extension KontaktCoordinator: ScannerCoordinationDelegate {
    func scannerDidFinishSuccessfully(_ success: Bool) {
        homeViewController.homeDelegate = self
        self.navigationController?.popViewController(animated: true)
    }
}
extension KontaktCoordinator: OnboardingCoordinationDelegate {
    func onboardingDidFinish() {
        infoViewController.infoDelegate = self
        self.navigationController?.pushViewController(infoViewController, animated: true)
    }
}
