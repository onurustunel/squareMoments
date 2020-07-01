//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by MEHMET ONUR ÜSTÜNEL on 14.03.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
   
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      
        
        
    }
    func makeAlert(titleInput: String, messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
     
         
         Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
         
         if error != nil {
         
         self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
         
         
         } else {
         
         if self.emailText.text != nil && self.passwordText.text != nil {
         self.performSegue(withIdentifier: "tofeedVC", sender: nil)
         
         }
         
         else {
         
         self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
          
         }
        }
         
         }

    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
    performSegue(withIdentifier: "toRegisterVC", sender: nil)
        // kayıt olmaya gitti
        
        
        
    }

}

