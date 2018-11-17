//
//  ViewController.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-09-13.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit

protocol HomeCoordinationDelegate: AnyObject {
    func homeDidFinishSuccessfully(_ success: Bool)
}

class HomeViewController: UIViewController {
    
    weak var homeDelegate: HomeCoordinationDelegate?
    @IBOutlet var qrCodeImage: UIImageView!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet var scannerButton: UIButton!
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        homeDelegate?.homeDidFinishSuccessfully(true)
    }
    
    @IBAction func scannerButtonTapped(_ sender: UIButton) {
        homeDelegate?.homeDidFinishSuccessfully(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 188.0/255.0, green: 136.0/255.0, blue: 8.0/255.0, alpha: 1.0)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
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

