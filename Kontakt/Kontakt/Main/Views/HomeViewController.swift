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
    @IBOutlet var imageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scannerButton.setupButtonAppearance()
        imageView.layer.cornerRadius = 12.0
        
//        let gradient = CAGradientLayer()
//        gradient.frame = self.view.bounds
//        gradient.colors = [#colorLiteral(red: 0, green: 0.8862745098, blue: 0.8196078431, alpha: 1), #colorLiteral(red: 0.2235294118, green: 0, blue: 0.5098039216, alpha: 1)]
//
//        self.view.layer.addSublayer(gradient)
        
        view.setGradientBackground(colorOne: #colorLiteral(red: 0, green: 0.8862745098, blue: 0.8196078431, alpha: 1), colorTwo: #colorLiteral(red: 0.2235294118, green: 0, blue: 0.5098039216, alpha: 1))
        
//        qrCodeImage.image = UIImage(named: "errorIcon")
        
//        var contactInfo = ""
//
//        if let x = UserDefaults.standard.object(forKey: "firstName") as? String {
//            contactInfo += "\(x),"
//        }
//        if let y = UserDefaults.standard.object(forKey: "lastName") as? String {
//            contactInfo += "\(y),"
//        }
//        if let z = UserDefaults.standard.object(forKey: "phoneNumber") as? String {
//            contactInfo += "\(z),"
//        }
//        if let q = UserDefaults.standard.object(forKey: "email") as? String {
//            contactInfo += "\(q),"
//        }
//        qrCodeImage.image = generateQRCode(from: contactInfo)
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
        qrCodeImage.image = generateQRCode(from: contactInfo)
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

