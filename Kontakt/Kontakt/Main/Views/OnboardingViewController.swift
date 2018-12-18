//
//  OnboardingViewController.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-12-13.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit

protocol OnboardingCoordinationDelegate: AnyObject {
    func onboardingDidFinish()
}

class OnboardingViewController: UIViewController {

    weak var onboardingDelegate: OnboardingCoordinationDelegate?
    @IBOutlet private var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: #colorLiteral(red: 0, green: 0.8862745098, blue: 0.8196078431, alpha: 1), colorTwo: #colorLiteral(red: 0.2235294118, green: 0, blue: 0.5098039216, alpha: 1))
        getStartedButton.setupButtonAppearance()
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
        onboardingDelegate?.onboardingDidFinish()
    }
}
