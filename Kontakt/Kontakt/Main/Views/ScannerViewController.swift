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
    
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var cameraView: UIView!
    @IBOutlet var infoTextView: UILabel!
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 153.0/255.0, green: 204.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        cameraView.backgroundColor = .black
        session = AVCaptureSession()
        let captureDevice = AVCaptureDevice.default(for: .video)
        
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
    
    private func importContact(firstName: String, lastName: String, phone: String, email: String, address: String) {
        let contact = CNMutableContact()
        
        contact.givenName = firstName
        contact.familyName = lastName
//        let phoneNumber = CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: phone))
//        contact.phoneNumbers = [phoneNumber]
////        let homeEmail = CNLabeledValue(label: CNLabelHome, value: email)
//        let homeAddress = CNMutablePostalAddress()
//        homeAddress.street = address
        
        store = CNContactStore()
        
        if UserDefaults.standard.bool(forKey: "contactPermission") {
            print("already asked camera")
        } else {
            store.requestAccess(for: .contacts) { (granted, error) in
                UserDefaults.standard.set(true, forKey: "contactPermission")
                if granted {
                    print("granted")
                } else {
                    print("not granted")
                }
            }
        }
        
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        print("hey")
        try! store.execute(saveRequest)
        print("fuck yeah")
    }
    
    private func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        session = nil
    }
    
    private func found(code: String) {
        print(code)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        session.stopRunning()
        if let metadataObject = metadataObjects.first {
            if let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject {
                if readableObject.type == AVMetadataObject.ObjectType.qr {
                    //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                    
                    let alert = UIAlertController(title: "Contact Detected", message: "Save Contact?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (nil) in
                        self.found(code: readableObject.stringValue!)
                        
                        let contactInfoData = readableObject.stringValue!
                        let contactInfoDataSplit = contactInfoData.split(separator: ",")
                        let firstNameSplit = String(contactInfoDataSplit[0])
                        let lastNameSplit = String(contactInfoDataSplit[1])
                        let phoneNumberSplit = String(contactInfoDataSplit[2])
                        let emailSplit = String(contactInfoDataSplit[3])
                        let addressSplit = String(contactInfoDataSplit[4])
                        
                        self.importContact(firstName: firstNameSplit, lastName: lastNameSplit, phone: phoneNumberSplit, email: emailSplit, address: addressSplit)
                        
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
//        dismiss(animated: true)
    }
}
