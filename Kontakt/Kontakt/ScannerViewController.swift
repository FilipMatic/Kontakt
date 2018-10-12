//
//  ScannerViewController.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-09-23.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    
    var video = AVCaptureVideoPreviewLayer()
    
    var contactInfoData = ""
//    var contactInfoDataSplit : [String] = []
    var firstNameSplit = ""
    var lastNameSplit = ""
    var phoneNumberSplit = ""
    var emailSplit = ""
    var addressSplit = ""
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var infoTextView: UILabel!
    
    @IBAction func HomeScreenButton(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 153.0/255.0, green: 204.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        cameraView.backgroundColor = .black
        
        print("entering")
        
        //Create session
        let session = AVCaptureSession()
        //Capture device
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch
        {
            print("error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = cameraView.layer.bounds
        cameraView.layer.addSublayer(video)
        print("running session")
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    {
        if (metadataObjects != nil) && (metadataObjects.count != 0)
        {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            {
                if object.type == AVMetadataObject.ObjectType.qr
                {
                    let alert = UIAlertController(title: "Contact Detected", message: object.stringValue, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                    alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: { (nil) in
//                        UIPasteboard.general.string = object.stringValue
//                    }))
                    present(alert, animated: true, completion: nil)
                }
                
                contactInfoData = object.stringValue! //THIS IS IMPORTANTE
                let contactInfoDataSplit = contactInfoData.split(separator: ",")
                
                firstNameSplit = String(contactInfoDataSplit[0])
                lastNameSplit = String(contactInfoDataSplit[1])
                phoneNumberSplit = String(contactInfoDataSplit[2])
                emailSplit = String(contactInfoDataSplit[3])
                addressSplit = String(contactInfoDataSplit[4])
                
            }
        }
    }
}
