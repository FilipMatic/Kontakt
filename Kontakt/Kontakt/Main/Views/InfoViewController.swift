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
    private var currentTextField: UITextField?
    private var keyboardActive: Bool = false
    
    @IBOutlet private var myKontaktLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var homeButton: UIButton!
    @IBOutlet private var generateButton: UIButton!
    
    @IBOutlet private var firstNameTextField: UITextField!
    @IBOutlet private var lastNameTextField: UITextField!
    @IBOutlet private var phoneNumberTextField: PhoneNumberTextField!
    @IBOutlet private var emailTextField: UITextField!
    
    @IBOutlet var kontaktLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var generateButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var lastNameTopConstraint: NSLayoutConstraint!
    @IBOutlet var phoneTopConstraint: NSLayoutConstraint!
    @IBOutlet var emailTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHomeButton()
        setTextFieldProperties()
        loadTextFields()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        homeButton.isHidden = !UserDefaults.standard.bool(forKey: "onboardingCompleted")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        keyboardActive = true
        
        if kontaktLabelTopConstraint.constant != 27 {
            return
        }
        
        myKontaktLabel.isHidden = true
        descriptionLabel.isHidden = true
        
        kontaktLabelTopConstraint.constant = -80
        generateButtonBottomConstraint.constant = generateButtonBottomConstraint.constant + (keyboardSize.height - 30)
        
//        kontaktLabelTopConstraint.constant = kontaktLabelTopConstraint.constant - (keyboardSize.height - 90)
        lastNameTopConstraint.constant = lastNameTopConstraint.constant - 15
        phoneTopConstraint.constant = phoneTopConstraint.constant - 15
        emailTopConstraint.constant = emailTopConstraint.constant - 15
//        generateButtonTopConstraint.constant = generateButtonTopConstraint.constant - 20
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        
        keyboardActive = true
        
        myKontaktLabel.isHidden = false
        descriptionLabel.isHidden = false
        
        kontaktLabelTopConstraint.constant = 27
        generateButtonBottomConstraint.constant = generateButtonBottomConstraint.constant - (keyboardSize.height - 30)
        
//        kontaktLabelTopConstraint.constant = kontaktLabelTopConstraint.constant + (keyboardSize.height - 90)
        lastNameTopConstraint.constant = lastNameTopConstraint.constant + 15
        phoneTopConstraint.constant = phoneTopConstraint.constant + 15
        emailTopConstraint.constant = emailTopConstraint.constant + 15
//        generateButtonTopConstraint.constant = generateButtonTopConstraint.constant + 20
        view.layoutIfNeeded()
    }
    
    @IBAction private func homeButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        infoDelegate?.infoDidFinishSuccessfully(true)
    }
    
    @IBAction private func generateButtonTapped(_ sender: UIButton) {
        contactInfoString = "\(firstNameTextField.text!),\(lastNameTextField.text!),\(phoneNumberTextField.text!),\(emailTextField.text!)"
        UserDefaults.standard.set(firstNameTextField.text, forKey: "firstName")
        UserDefaults.standard.set(lastNameTextField.text, forKey: "lastName")
        UserDefaults.standard.set(phoneNumberTextField.text, forKey: "phoneNumber")
        UserDefaults.standard.set(emailTextField.text, forKey: "email")
        
        dismissKeyboard()
        
        if !UserDefaults.standard.bool(forKey: "onboardingCompleted") {
            infoDelegate?.infoDidFinishSuccessfully(false)
        } else {
            infoDelegate?.infoDidFinishSuccessfully(true)
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
    
    private func dismissKeyboard() {
        if currentTextField == firstNameTextField {
            firstNameTextField.resignFirstResponder()
        } else if currentTextField == lastNameTextField {
            lastNameTextField.resignFirstResponder()
        } else if currentTextField == phoneNumberTextField {
            phoneNumberTextField.resignFirstResponder()
        } else if currentTextField == emailTextField {
            emailTextField.resignFirstResponder()
        }
    }
    
    private func loadTextFields() {
        if let firstNameFieldString = UserDefaults.standard.string(forKey: "firstName") {
            firstNameTextField.text = firstNameFieldString
        }
        if let lastNameFieldString = UserDefaults.standard.string(forKey: "lastName") {
            lastNameTextField.text = lastNameFieldString
        }
        if let phoneNumberFieldString = UserDefaults.standard.string(forKey: "phoneNumber") {
            phoneNumberTextField.text = phoneNumberFieldString
        }
        if let emailFieldString = UserDefaults.standard.string(forKey: "email") {
            emailTextField.text = emailFieldString
        }
    }
    
    private func setTextFieldProperties() {
        firstNameTextField.delegate = self
        firstNameTextField.tag = 100
        
        lastNameTextField.delegate = self
        lastNameTextField.tag = 200
        
        phoneNumberTextField.delegate = self
        phoneNumberTextField.tag = 300
        
        emailTextField.delegate = self
        emailTextField.tag = 400
        
        firstNameTextField.autocorrectionType = .no
        firstNameTextField.autocapitalizationType = .words
        firstNameTextField.setupTextFieldAppearance()
        
        lastNameTextField.autocorrectionType = .no
        lastNameTextField.autocapitalizationType = .words
        lastNameTextField.setupTextFieldAppearance()
        
        phoneNumberTextField.setupTextFieldAppearance()
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.setupTextFieldAppearance()
    }
}

extension InfoViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            phoneNumberTextField.becomeFirstResponder()
        } else if textField == phoneNumberTextField {
            emailTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
    }
}
