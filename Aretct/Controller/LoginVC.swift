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
    
    
    //Variables
    let loginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Actions
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
        
        //公式サイト確認する
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
    @IBAction func fbLoginClicked(_ sender: Any) {
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else if result?.isCancelled ?? true {
                
            } else {
              self.signinFirebaseFacebook()
            }
        }
    }
    
    func signinFirebaseFacebook() {
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        
        guard let user = Auth.auth().currentUser else {return}
        user.link(with: credential) { (result, error) in
            self.handlePotensialFirstTImeFbLogin()
        }
    }
    
    func handlePotensialFirstTImeFbLogin() {
        guard  let user = Auth.auth().currentUser else { return }
        Firestore.firestore().collection("users").document(user.uid).getDocument { (snap, error) in
            
            guard let snap = snap else {return}
            if snap.exists {
                if let data = snap.data() {
                    guard let hasSetup = data["hasSetupAccount"] as? Bool else {return}
                    if hasSetup {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        
                        self.presentFirstTimeAlert()
                    }
                }
            } else {
                self.handleNewUser()
            }
            
           
        }
    }
    
    func handleNewUser() {
        guard let user = Auth.auth().currentUser else {return}
        
        
        
        var userData = [String: Any]()
        userData = [
            "email": "",
            "username": "",
            "avaturUrl": "",
            "hasSetupAccount": false,
            "isGuest": false,
        ]
        
        Firestore.firestore().collection("users").document(user.uid).setData(userData) { (error) in
            if let error = error {
                debugPrint(error.localizedDescription)
//                self.handleFireAuthError(error)
                return
            }
            self.presentFirstTimeAlert()
        }
    }
    
    func presentFirstTimeAlert() {
        let alert = UIAlertController(title: "Welcome", message: "Look like you are new here. Let's get you set up", preferredStyle: .alert)
        let notNow = UIAlertAction(title: "Not Now", style: .cancel) { (alert) in
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            self.performSegue(withIdentifier: Segues.ToRegisterAccount, sender: self)
            
        }
        alert.addAction(notNow)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
}
