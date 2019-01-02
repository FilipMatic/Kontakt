//
//  ScannerViewController.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-09-23.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit
import AVFoundation
import Contacts

protocol ScannerCoordinationDelegate: AnyObject {
    func scannerDidFinishSuccessfully(_ success: Bool)
}

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    weak var scannerDelegate: ScannerCoordinationDelegate?
    
    var session: AVCaptureSession!
    var store: CNContactStore!
    var video = AVCaptureVideoPreviewLayer()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    @IBOutlet private var homeButton: UIButton!
    @IBOutlet private var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setGradientBackground(colorOne: #colorLiteral(red: 0, green: 0.8862745098, blue: 0.8196078431, alpha: 1), colorTwo: #colorLiteral(red: 0.2235294118, green: 0, blue: 0.5098039216, alpha: 1))
        setupHomeButton()
        self.view.bringSubviewToFront(homeButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (session?.isRunning == false) {
            session.startRunning();
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (session?.isRunning == true) {
            session.stopRunning();
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            if let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject {
                if readableObject.type == AVMetadataObject.ObjectType.qr {
                    
                    let alert = UIAlertController(title: "Contact Detected", message: "Save Contact?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (nil) in
                        
                        let contactInfoData = readableObject.stringValue!
                        let contactInfoDataSplit = contactInfoData.split(separator: ",")
                        let firstNameSplit = String(contactInfoDataSplit[0])
                        let lastNameSplit = String(contactInfoDataSplit[1])
                        let phoneNumberSplit = String(contactInfoDataSplit[2])
                        let emailSplit = String(contactInfoDataSplit[3])
                        
                        self.importContact(firstName: firstNameSplit, lastName: lastNameSplit, phone: phoneNumberSplit, email: emailSplit as NSString)
                        
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction private func homeButtonTapped(_ sender: UIButton) {
        scannerDelegate?.scannerDidFinishSuccessfully(true)
    }
    
    private func setupHomeButton() {
        let homeArrowImage = UIImage(named: "HomeArrow")
        let tintedImage = homeArrowImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        homeButton.setBackgroundImage(tintedImage, for: .normal)
        homeButton.tintColor = UIColor.white
    }
    
    private func startSession() {
        session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        var videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice!)
        } catch {
            return
        }
        
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (session.canAddOutput(metadataOutput)) {
            session.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = cameraView.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
    
    private func importContact(firstName: String, lastName: String, phone: String, email: NSString) {
        let contact = CNMutableContact()
        
        contact.givenName = firstName
        contact.familyName = lastName
        let phoneNumber = CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: phone))
        contact.phoneNumbers = [phoneNumber]
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: email)
        contact.emailAddresses = [homeEmail]
        
        store = CNContactStore()
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        try! store.execute(saveRequest)
        session.stopRunning()
        scannerDelegate?.scannerDidFinishSuccessfully(true)
    }
    
    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        session = nil
    }
}
