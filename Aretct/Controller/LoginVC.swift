//
//  LoginVC.swift
//  Aretct
//
//  Created by yw on 2019/08/20.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FirebaseFirestore

class LoginVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func forgotPassClicked(_ sender: Any) {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loginClicked(_ sender: Any) {
        //""だとisEmptyは trueになる
        guard let email = emailTxt.text, email.isNotEmpty,
            let password = passTxt.text, password.isNotEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out all fields")
                return
        }
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                self.activityIndicator.stopAnimating()
                return
            }
            
            self.activityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func guestClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
