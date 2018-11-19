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
    
    let phoneNumberKit = PhoneNumberKit()
    
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var generateButton: UIButton!
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var phoneNumber: PhoneNumberTextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var displayScreen: UITextView!
    @IBOutlet var qrCodeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.init(red: 153.0/255.0, green: 204.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        self.view.backgroundColor = UIColor.init(red: 153.0/255.0, green: 101.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        generateButton.setupButtonAppearance()
        
        firstName.delegate = self
        lastName.delegate = self
        phoneNumber.delegate = self
        email.delegate = self
        address.delegate = self
        
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
        
        address.autocorrectionType = .no
        address.autocapitalizationType = .words
        address.setupTextFieldAppearance()
        
        qrCodeImage.image = UIImage(named: "errorIcon")
        
        var contactInfo = ""
        
        if let x = UserDefaults.standard.object(forKey: "firstName") as? String {
            contactInfo += "\(x),"
        }
        if let y = UserDefaults.standard.object(forKey: "lastName") as? String {
            contactInfo += "\(y),"
        }
        if let z = UserDefaults.standard.object(forKey: "phoneNumber") as? String {
            contactInfo += "\(z),"
        }
        if let q = UserDefaults.standard.object(forKey: "email") as? String {
            contactInfo += "\(q),"
        }
        if let w = UserDefaults.standard.object(forKey: "address") as? String {
            contactInfo += "\(w)"
            qrCodeImage.image = generateQRCode(from: contactInfo)
        }
        displayScreen.text = contactInfo
    }
    
    @IBAction private func homeButtonTapped(_ sender: UIButton) {
        infoDelegate?.infoDidFinishSuccessfully(true)
    }
    
    @IBAction private func generateButtonTapped(_ sender: UIButton) {
        displayScreen.text = "\(firstName.text!),\(lastName.text!),\(phoneNumber.text!),\(email.text!),\(address.text!)"
        UserDefaults.standard.set(firstName.text, forKey: "firstName")
        firstName.text = ""
        UserDefaults.standard.set(lastName.text, forKey: "lastName")
        lastName.text = ""
        UserDefaults.standard.set(phoneNumber.text, forKey: "phoneNumber")
        phoneNumber.text = ""
        
        UserDefaults.standard.set(address.text, forKey: "address")
        address.text = ""
        
        UserDefaults.standard.set(displayScreen.text, forKey: "contactInfo")

        if isValidEmail(emailStr: email.text!) {
            if email.checkIfErrorColor() {
                email.setValidBorderColor()
                email.layoutIfNeeded()
            }
            UserDefaults.standard.set(email.text, forKey: "email")
            email.text = ""
            if let infoString = displayScreen.text {
                qrCodeImage.image = generateQRCode(from: infoString)
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.email.setErrorBorderColor()
            }) { _ in
                self.email.shake(horizontally: 4.0, vertically: 0.0)
            }
        }
        
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return UIImage(named: "errorIcon")
    }
    
    private func isNameValid(nameStr: String) -> Bool {
        let nameRegEx = "/^[a-z ,.'-]+$/i"
        
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: nameStr)
    }
    
//    private func isPhoneNumberValid(phoneStr: String) -> Bool {
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
}

extension InfoViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
