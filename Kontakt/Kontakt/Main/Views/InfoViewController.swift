//
//  InfoViewController.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-09-15.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit
import PhoneNumberKit

protocol InfoCoordinationDelegate: AnyObject {
    func infoDidFinishSuccessfully(_ success: Bool)
}

class InfoViewController: UIViewController {
    
    weak var infoDelegate: InfoCoordinationDelegate?
    
    private let phoneNumberKit = PhoneNumberKit()
    
    private var contactInfoString: String?
    
    @IBOutlet private var myKontaktLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var homeButton: UIButton!
    @IBOutlet private var generateButton: UIButton!
    
    @IBOutlet private var firstName: UITextField!
    @IBOutlet private var lastName: UITextField!
    @IBOutlet private var phoneNumber: PhoneNumberTextField!
    @IBOutlet private var email: UITextField!
    
    @IBOutlet var kontaktLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var generateButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHomeButton()
        setTextFieldProperties()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        homeButton.isHidden = !UserDefaults.standard.bool(forKey: "onboardingCompleted")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        print("keyboard will show: \(notification.name.rawValue)")
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        myKontaktLabel.isHidden = true
        descriptionLabel.isHidden = true
        
//        generateButtonTopConstraint.constant = 15
        kontaktLabelTopConstraint.constant = kontaktLabelTopConstraint.constant - (keyboardSize.height - 100)
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        myKontaktLabel.isHidden = false
        descriptionLabel.isHidden = false
        
        kontaktLabelTopConstraint.constant = kontaktLabelTopConstraint.constant + (keyboardSize.height - 100)
//        generateButtonTopConstraint.constant = keyboardSize
        view.layoutIfNeeded()
    }
    
    @IBAction private func homeButtonTapped(_ sender: UIButton) {
        infoDelegate?.infoDidFinishSuccessfully(true)
    }
    
    @IBAction private func generateButtonTapped(_ sender: UIButton) {
        contactInfoString = "\(firstName.text!),\(lastName.text!),\(phoneNumber.text!),\(email.text!)"
        UserDefaults.standard.set(firstName.text, forKey: "firstName")
        UserDefaults.standard.set(lastName.text, forKey: "lastName")
        UserDefaults.standard.set(email.text, forKey: "email")
        UserDefaults.standard.set(phoneNumber.text, forKey: "phoneNumber")
        
        if !UserDefaults.standard.bool(forKey: "onboardingCompleted") {
            infoDelegate?.infoDidFinishSuccessfully(false)
        }
        
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
    }
    
    private func setupView() {
        view.setGradientBackground(colorOne: #colorLiteral(red: 0, green: 0.8862745098, blue: 0.8196078431, alpha: 1), colorTwo: #colorLiteral(red: 0.2235294118, green: 0, blue: 0.5098039216, alpha: 1))
        generateButton.setupButtonAppearance()
    }
    
    private func setupHomeButton() {
        let homeArrowImage = UIImage(named: "HomeArrow")
        let tintedImage = homeArrowImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        homeButton.setBackgroundImage(tintedImage, for: .normal)
        homeButton.tintColor = UIColor.white
    }
    
    private func setTextFieldProperties() {
        firstName.delegate = self
        firstName.tag = 100
        
        lastName.delegate = self
        lastName.tag = 200
        
        phoneNumber.delegate = self
        phoneNumber.tag = 300
        
        email.delegate = self
        email.tag = 400
        
        firstName.autocorrectionType = .no
        firstName.autocapitalizationType = .words
        firstName.setupTextFieldAppearance()
        
        lastName.autocorrectionType = .no
        lastName.autocapitalizationType = .words
        lastName.setupTextFieldAppearance()
        
        phoneNumber.setupTextFieldAppearance()
        
        email.keyboardType = .emailAddress
        email.autocorrectionType = .no
        email.autocapitalizationType = .none
        email.setupTextFieldAppearance()
    }
}

extension InfoViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === firstName {
            lastName.becomeFirstResponder()
        } else if textField == lastName {
            phoneNumber.becomeFirstResponder()
        } else if textField == phoneNumber {
            email.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
