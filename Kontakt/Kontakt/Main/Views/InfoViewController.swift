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
    @IBOutlet private var address: UITextField!
    
    @IBOutlet var qrCodeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 153.0/255.0, green: 101.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        generateButton.setupButtonAppearance()
        
        firstName.delegate = self
        firstName.tag = 100
        
        lastName.delegate = self
        lastName.tag = 200
        
        phoneNumber.delegate = self
        phoneNumber.tag = 300
        
        email.delegate = self
        email.tag = 400
        
        address.delegate = self
        address.tag = 500
        
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
            firstName.text = x
        }
        if let y = UserDefaults.standard.object(forKey: "lastName") as? String {
            contactInfo += "\(y),"
            lastName.text = y
        }
        if let z = UserDefaults.standard.object(forKey: "phoneNumber") as? String {
            contactInfo += "\(z),"
            phoneNumber.text = z
        }
        if let q = UserDefaults.standard.object(forKey: "email") as? String {
            contactInfo += "\(q),"
            email.text = q
        }
        if let w = UserDefaults.standard.object(forKey: "address") as? String {
            contactInfo += "\(w)"
            address.text = w
            qrCodeImage.image = generateQRCode(from: contactInfo)
        }
    }
    
    @IBAction private func homeButtonTapped(_ sender: UIButton) {
        infoDelegate?.infoDidFinishSuccessfully(true)
    }
    
    @IBAction private func generateButtonTapped(_ sender: UIButton) {
        contactInfoString = "\(firstName.text!),\(lastName.text!),\(phoneNumber.text!),\(email.text!),\(address.text!)"
        UserDefaults.standard.set(firstName.text, forKey: "firstName")
        UserDefaults.standard.set(lastName.text, forKey: "lastName")
        UserDefaults.standard.set(email.text, forKey: "email")
        UserDefaults.standard.set(phoneNumber.text, forKey: "phoneNumber")
        UserDefaults.standard.set(address.text, forKey: "address")

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
        
        if let infoString = contactInfoString {
            qrCodeImage.image = generateQRCode(from: infoString)
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
    
    private func isValidName(nameStr: String) -> Bool {
        let nameRegEx = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
        
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: nameStr)
    }
    
//    private func isValidPhoneNumber(phoneStr: String) -> Bool {
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
    
//    private func isValidAddress(addressStr: String) -> Bool {
//        let addressRegEx = ""
//
//        let addressTest = NSPredicate(format: "SELF MATCHES %@", addressRegEx)
//        return addressTest.evaluate(with: addressStr)
//    }
    
    func shakeEmail(horizontally: CGFloat = 0, vertically: CGFloat = 0) {
        let animation = CABasicAnimation(keyPath: "shake")
        animation.duration = 0.05
        animation.repeatCount = 5.0
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: email.center.x - horizontally, y: email.center.y - horizontally))
        animation.toValue = NSValue(cgPoint: CGPoint(x: email.center.x + horizontally, y: email.center.y + horizontally))
        
        email.layer.add(animation, forKey: "shake")
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
