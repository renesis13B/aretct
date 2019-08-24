//
//  LoginVC.swift
//  Aretct
//
//  Created by yw on 2019/08/20.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    //Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Actions
    @IBAction func forgotPassClicked(_ sender: Any) {
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        //""だとisEmptyは trueになる
        guard let email = emailTxt.text, email.isNotEmpty,
            let password = passTxt.text, password.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out all fields")
                return
                
        }
        
        activityIndicator.startAnimating()
        
        //公式サイト確認する
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                debugPrint(error)
                self.handleFireAuthError(error: error)
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func guestClicked(_ sender: Any) {
    }
}
