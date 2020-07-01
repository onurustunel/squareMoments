//
//  signUpVC.swift
//  squareMoments
//
//  Created by MEHMET ONUR ÜSTÜNEL on 29.06.2020.
//  Copyright © 2020 MEHMET ONUR ÜSTÜNEL. All rights reserved.
//

import UIKit
import Firebase


class signUpVC: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
    @IBAction func haveAccountClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toLoginVC", sender: nil)
       
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        
         if emailText.text != "" && passwordText.text != ""  {
         
         
         Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authdata, error) in
         
         if error != nil {
         
         self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "error")
         
         
         }
         else {
         
         self.performSegue(withIdentifier: "fromRegisterToFeed", sender: nil)
        
         }
         
         }
         
         }
         
         else {
         makeAlert(titleInput: "ERROR", messageInput: " There is a mistake!")
         }
          
        }
   
        func makeAlert(titleInput: String, messageInput: String) {
            
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        }
    
}
