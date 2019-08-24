//
//  RegisterVC.swift
//  Aretct
//
//  Created by yw on 2019/08/20.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var activityIndicater: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Action
    @IBAction func registerNewMemberClicked(_ sender: Any) {
        guard let email = emailTxt.text, !email.isEmpty,
            let username = usernameTxt.text, !username.isEmpty,
            let password = passwordTxt.text, !password.isEmpty else {
                simpleAlert(title: "Error", msg: "Please fill out all fields.")
                return
        }
        
        guard let confirmPass = confirmPasswordTxt.text, confirmPass == password else {
            simpleAlert(title: "Error", msg: "Password do not match")
            return
        }
        
        activityIndicater.startAnimating()
        
        guard let authUser = Auth.auth().currentUser else {return}
        //credential(資格情報)
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        //承認されたプロパイダーを現在認証されているユーザーにリンクさせる
        //今回はメールによる資格情報に一連のキーを与えている
        authUser.link(with: credential) { (result, error) in
            //エラー処理
            if let error = error {
                debugPrint(error)
                self.handleFireAuthError(error: error)
                return
            }
            
            self.activityIndicater.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
