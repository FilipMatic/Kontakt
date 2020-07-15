//
//  ViewController.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-09-13.
//  Copyright © 2018 Filip Matić. All rights reserved.
//
//  HomeViewController class is resposible for implementing the logic for home screen

import UIKit
import AVFoundation
import Contacts

// Protocol implemented by the delegate of the home view controller
protocol HomeCoordinationDelegate: AnyObject {
    func homeDidFinishSuccessfully(_ success: Bool)
}

class HomeViewController: UIViewController {
    
    weak var homeDelegate: HomeCoordinationDelegate? // will be assigned to the instance of KontaktCoordinator
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
    
    // Function is responsible for getting the user's contact information and sending that info to generate a QR code
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
    
    // Function is responsible for generating a QR code based on user's contact information
    // using Apple's Core Image and CoreGraphics frameworks
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
    
    // Function is respondible for requesting camera and contact book permissions if not already requested
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

