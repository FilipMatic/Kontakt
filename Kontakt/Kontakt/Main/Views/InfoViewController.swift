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
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        infoDelegate?.infoDidFinishSuccessfully(true)
    }
    
    @IBAction func generateButtonTapped(_ sender: Any) {
        displayScreen.text = "\(firstName.text!),\(lastName.text!),\(phoneNumber.text!),\(email.text!),\(address.text!)"
        UserDefaults.standard.set(firstName.text, forKey: "firstName")
        firstName.text = ""
        UserDefaults.standard.set(lastName.text, forKey: "lastName")
        lastName.text = ""
        UserDefaults.standard.set(phoneNumber.text, forKey: "phoneNumber")
        phoneNumber.text = ""
        UserDefaults.standard.set(email.text, forKey: "email")
        email.text = ""
        UserDefaults.standard.set(address.text, forKey: "address")
        address.text = ""
        
        if let infoString = displayScreen.text {
            let infoData = infoString.data(using: .ascii, allowLossyConversion: false)
            let infoFilter = CIFilter(name: "CIQRCodeGenerator")
            infoFilter?.setValue(infoData, forKey: "inputMessage")

            let infoImage = UIImage(ciImage: (infoFilter?.outputImage)!)

            qrCodeImage.image = infoImage
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 153.0/255.0, green: 204.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        
        firstName.delegate = self
        lastName.delegate = self
        phoneNumber.delegate = self
        email.delegate = self
        address.delegate = self
//        qrCodeImage.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var info = ""
        var infoForCode: String!
        infoForCode = ""
        
        if let x = UserDefaults.standard.object(forKey: "firstName") as? String {
            info += "\(x),"
            infoForCode += "\(x),"
        }
        if let y = UserDefaults.standard.object(forKey: "lastName") as? String {
            info += "\(y),"
            infoForCode += "\(y),"
        }
        if let z = UserDefaults.standard.object(forKey: "phoneNumber") as? String {
            info += "\(z),"
            infoForCode += "\(z),"
        }
        if let q = UserDefaults.standard.object(forKey: "email") as? String {
            info += "\(q),"
            infoForCode += "\(q),"
        }
        if let w = UserDefaults.standard.object(forKey: "address") as? String {
            info += "\(w)"
            infoForCode += "\(w)"
            
            //need to change this!!!!! THIS IS CHEATING
            if let infoString = infoForCode {
                let infoData = infoString.data(using: .ascii, allowLossyConversion: false)
                let infoFilter = CIFilter(name: "CIQRCodeGenerator")
                infoFilter?.setValue(infoData, forKey: "inputMessage")
                
                let infoImage = UIImage(ciImage: (infoFilter?.outputImage)!)
                
                qrCodeImage.image = infoImage
            }
        }
        
        displayScreen.text = info
    }
}

extension InfoViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
