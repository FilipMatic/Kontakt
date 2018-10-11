//
//  ViewController.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-09-13.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBAction func infoScreenButton(_ sender: Any)
    {
        performSegue(withIdentifier: "InfoScreenSeg", sender: self)
    }
    
    @IBAction func scannerScreenButton(_ sender: Any)
    {
        performSegue(withIdentifier: "ScannerScreenSeg", sender: self)
    }
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.init(red: 188.0/255.0, green: 136.0/255.0, blue: 8.0/255.0, alpha: 1.0)
        qrCodeImage.image = UIImage(named: "youngBrandonIngram")
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

