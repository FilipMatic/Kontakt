//
//  InfoViewController.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-09-15.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
//    var previouslyLoaded = false
//    var generatedBarcode: UIImage!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var displayScreen: UITextView!
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    @IBAction func HomeScreenButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func GenerateButton(_ sender: Any) {
//        displayScreen.text = "First Name: \(firstName.text!)\nLast Name: \(lastName.text!)\n\nPhone Number: \(phoneNumber.text!)\n\nEmail: \(email.text!)\n\nAddress: \(address.text!)"
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
