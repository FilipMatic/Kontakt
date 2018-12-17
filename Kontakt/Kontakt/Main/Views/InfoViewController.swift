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
    
    @IBOutlet private var homeButton: UIButton!
    @IBOutlet private var generateButton: UIButton!
    
    @IBOutlet private var firstName: UITextField!
    @IBOutlet private var lastName: UITextField!
    @IBOutlet private var phoneNumber: PhoneNumberTextField!
    @IBOutlet private var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorOne: #colorLiteral(red: 0, green: 0.8862745098, blue: 0.8196078431, alpha: 1), colorTwo: #colorLiteral(red: 0.2235294118, green: 0, blue: 0.5098039216, alpha: 1))
        generateButton.setupButtonAppearance()
        
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
    
    @IBAction private func homeButtonTapped(_ sender: UIButton) {
        infoDelegate?.infoDidFinishSuccessfully(true)
    }
    
    @IBAction private func generateButtonTapped(_ sender: UIButton) {
        contactInfoString = "\(firstName.text!),\(lastName.text!),\(phoneNumber.text!),\(email.text!)"
        UserDefaults.standard.set(firstName.text, forKey: "firstName")
        UserDefaults.standard.set(lastName.text, forKey: "lastName")
        UserDefaults.standard.set(email.text, forKey: "email")
        UserDefaults.standard.set(phoneNumber.text, forKey: "phoneNumber")

//        if isValidEmail(emailStr: email.text!) {
//            if email.checkIfErrorColor() {
//                email.setValidBorderColor()
//                email.layoutIfNeeded()
//            }
//            UserDefaults.standard.set(email.text, forKey: "email")
//            email.text = ""
//            if let infoString = displayScreen.text {
//                qrCodeImage.image = generateQRCode(from: infoString)
//            }
//        } else {
//            UIView.animate(withDuration: 0.3, animations: {
//                self.email.setErrorBorderColor()
//            }) { _ in
//                self.email.shake(horizontally: 4.0, vertically: 0.0)
//            }
//        }
//
//        if isValidName(nameStr: firstName.text!) && isValidName(nameStr: lastName.text!) && isValidEmail(emailStr: email.text!) {
//            if let infoString = displayScreen.text {
//                qrCodeImage.image = generateQRCode(from: infoString)
//            }
//        } else {
//            qrCodeImage.image = UIImage(named: "errorIcon")
//        }
    }
    
    private func isValidName(nameStr: String) -> Bool {
        let nameRegEx = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
        
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: nameStr)
    }
    
//    private func isValidPhone(phoneStr: String) -> Bool {
//        let phoneRegEx = "^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$"
//
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
//        return phoneTest.ev
//    }
    
    private func isValidEmail(emailStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailStr)
    }
    
    private func shakeEmail(horizontally: CGFloat = 0, vertically: CGFloat = 0) {
        let animation = CABasicAnimation(keyPath: "shake")
        animation.duration = 0.05
        animation.repeatCount = 5.0
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: email.center.x - horizontally, y: email.center.y - horizontally))
        animation.toValue = NSValue(cgPoint: CGPoint(x: email.center.x + horizontally, y: email.center.y + horizontally))
        
        email.layer.add(animation, forKey: "shake")
    }
    
    private func setupScreen() {
        
    }
}

extension InfoViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 100, 200:
            if isValidName(nameStr: firstName.text!) {
                if firstName.checkIfErrorColor() {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.firstName.setValidBorderColor()
                    }) { _ in
                        self.firstName.layoutIfNeeded()
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.firstName.setErrorBorderColor()
                }) { _ in
                    self.firstName.layoutIfNeeded()
                }
            }
        case 400:
            if isValidEmail(emailStr: email.text!) {
                if email.checkIfErrorColor() {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.email.setValidBorderColor()
                    }) { _ in
                        self.email.layoutIfNeeded()
                    }
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.email.setErrorBorderColor()
                }) { _ in
                    self.email.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
}
