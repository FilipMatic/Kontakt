//
//  InfoViewController.swift
//  Kontakt
//
//  Created by Filip Matić on 2018-09-15.
//  Copyright © 2018 Filip Matić. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController
{
    
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var address: UITextField!
    
    @IBOutlet weak var displayScreen: UITextView!
    
    @IBAction func HomeScreenButton(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func GenerateButton(_ sender: Any)
    {
        displayScreen.text = "First Name: \(firstName.text!)\nLast Name: \(lastName.text!)\n\nPhone Number: \(phoneNumber.text!)\n\nEmail: \(email.text!)\n\nAddress: \(address.text!)"
        UserDefaults.standard.set(firstName.text, forKey: "firstName")
        firstName.text = ""
        UserDefaults.standard.set(lastName.text, forKey: "lastName")
        lastName.text = ""
        UserDefaults.standard.set(phoneNumber.text, forKey: "phoneNumber")
        phoneNumber.text = ""
        UserDefaults.standard.set(email.text, forKey: "email")
        email.text = ""
        UserDefaults.standard.set(address.text, forKey: "address")
        address.text = ""
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(red: 153.0/255.0, green: 204.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        firstName.delegate = self
        lastName.delegate = self
        phoneNumber.delegate = self
        email.delegate = self
        address.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        var info = ""
        
        if let x = UserDefaults.standard.object(forKey: "firstName") as? String
        {
            info += "First Name: \(x)\n"
        }
        if let y = UserDefaults.standard.object(forKey: "lastName") as? String
        {
            info += "Last Name: \(y)\n\n"
        }
        if let z = UserDefaults.standard.object(forKey: "phoneNumber") as? String
        {
            info += "Phone Number: \(z)\n\n"
        }
        if let q = UserDefaults.standard.object(forKey: "email") as? String
        {
            info += "Email: \(q)\n\n"
        }
        if let w = UserDefaults.standard.object(forKey: "address") as? String
        {
            info += "Address: \(w)"
        }
        
        displayScreen.text = info
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension InfoViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
