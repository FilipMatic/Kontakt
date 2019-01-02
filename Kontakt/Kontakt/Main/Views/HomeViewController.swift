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
    @IBOutlet private var qrCodeImage: UIImageView!
    @IBOutlet private var infoButton: UIButton!
    @IBOutlet private var scannerButton: UIButton!
    @IBOutlet private var imageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getContactInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestPermissionsIfNeeded()
    }
    
    @IBAction private func infoButtonTapped(_ sender: UIButton) {
        homeDelegate?.homeDidFinishSuccessfully(true)
    }
    
    @IBAction private func scannerButtonTapped(_ sender: UIButton) {
        homeDelegate?.homeDidFinishSuccessfully(false)
    }
    
    private func setupView() {
        scannerButton.setupButtonAppearance()
        imageView.layer.cornerRadius = 12.0
        
        view.setGradientBackground(colorOne: #colorLiteral(red: 0, green: 0.8862745098, blue: 0.8196078431, alpha: 1), colorTwo: #colorLiteral(red: 0.2235294118, green: 0, blue: 0.5098039216, alpha: 1))
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
    
    private func getContactInfo() {
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
    
    private func requestPermissionsIfNeeded() {
        if !UserDefaults.standard.bool(forKey: "cameraPermission") {
            AVCaptureDevice.requestAccess(for: .video) { (response) in
                UserDefaults.standard.set(true, forKey: "cameraPermission")
            }
        }
        
        let store = CNContactStore()
        
        if !UserDefaults.standard.bool(forKey: "contactPermission") {
            store.requestAccess(for: .contacts) { (granted, error) in
                UserDefaults.standard.set(true, forKey: "contactPermission")
            }
        }
    }
}

