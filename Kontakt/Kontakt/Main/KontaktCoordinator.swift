//
//  KontaktCoordinator.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-11-05.
//  Copyright © 2018 Filip Matić. All rights reserved.
//
//  KontaktCoordinator implements the Coordinator protocol and is responsible for determining the appropriate view to display to the user.

import UIKit

final class KontaktCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var presentingViewController: UIViewController?
    
    // Resposible for controlling the navigation of the view controllers
    let navigationController: UINavigationController?
    
    // Instantiating the view controllers from the storyboard
    lazy private var homeViewController = StoryboardScene.Main.homeViewController.instantiate()
    lazy private var infoViewController = StoryboardScene.Main.infoViewController.instantiate()
    lazy private var scannerViewController = StoryboardScene.Main.scannerViewController.instantiate()
    lazy private var onboardingViewController = StoryboardScene.Main.onboardingViewController.instantiate()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // Function will present the appropriate view controller determined by the key 'onboardingCompleted'
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

// Below are extensions of the class to adopt to the specified protocol and implement its function

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
            // TODO: figure out why app crashes if viewController is simply pushed onto the stack once
            // Seems as though this temporarily fixes the animation issue when pushing the viewController once after clearing the viewControllers array
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
