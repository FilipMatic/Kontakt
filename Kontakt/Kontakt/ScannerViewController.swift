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
    
    @IBOutlet weak var cameraView: UIView!
    
//    @IBAction func HomeScreenButton(_ sender: Any)
//    {
//        dismiss(animated: true, completion: nil)
//    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 153.0/255.0, green: 204.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        cameraView.backgroundColor = .clear
        
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
//        video.frame = cameraView.layer.bounds
        video.frame = self.view.layer.bounds
        cameraView.layer.addSublayer(video)
        
        
        print("running session")
//        session.startRunning()
    }


}
