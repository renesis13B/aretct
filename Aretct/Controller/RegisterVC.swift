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
    
    @IBAction func registerNewMemberClicked(_ sender: Any) {
        guard let email = emailTxt.text, !email.isEmpty,
            let username = usernameTxt.text, !username.isEmpty,
            let password = passwordTxt.text, !password.isEmpty else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            //エラー処理
            if let error = error {
                debugPrint(error)
                return
            }
            
            print("Succese register new uset")
        }
    }
    
}
