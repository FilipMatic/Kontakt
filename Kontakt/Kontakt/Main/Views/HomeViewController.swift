//
//  ViewController.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-09-13.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit
import AVFoundation
import Contacts

protocol HomeCoordinationDelegate: AnyObject {
    func homeDidFinishSuccessfully(_ success: Bool)
}

class HomeViewController: UIViewController {
    
    weak var homeDelegate: HomeCoordinationDelegate?
    @IBOutlet var qrCodeImage: UIImageView!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var scannerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 153.0/255.0, green: 101.0/255.0, blue: 21.0/255.0, alpha: 1.0)
        
        infoButton.setupButtonAppearance()
        scannerButton.setupButtonAppearance()
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "cameraPermission") {
            print("already asked")
        } else {
            AVCaptureDevice.requestAccess(for: .video) { (response) in
                UserDefaults.standard.set(true, forKey: "cameraPermission")
                if response {
                    print("access granted")
                } else {
                    print("access denied")
                }
            }
        }
        
        let store = CNContactStore()
        
        if UserDefaults.standard.bool(forKey: "contactPermission") {
            print("already asked for contact")
        } else {
            store.requestAccess(for: .contacts) { (granted, error) in
                UserDefaults.standard.set(true, forKey: "contactPermission")
                if granted {
                    print("contact granted")
                } else {
                    print("contact not granted")
                }
            }
        }
    }
    
    @IBAction private func infoButtonTapped(_ sender: UIButton) {
        homeDelegate?.homeDidFinishSuccessfully(true)
    }
    
    @IBAction private func scannerButtonTapped(_ sender: UIButton) {
        homeDelegate?.homeDidFinishSuccessfully(false)
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
}

