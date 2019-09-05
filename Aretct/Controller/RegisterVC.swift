//
//  RegisterVC.swift
//  Aretct
//
//  Created by yw on 2019/08/20.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import Kingfisher

class RegisterVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var activityIndicater: UIActivityIndicatorView!
    @IBOutlet weak var fbAvatar: UIImageView!
    
    @IBOutlet weak var linkFbBtn: RoundedButton!
    //Variables
     let loginManager = LoginManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if AccessToken.current != nil {
            fetchFbData()
        }
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
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            if let error = error {
//                debugPrint(error)
//                Auth.auth().handleFireAuthError(error: error, vc: self)
//                return
//            }
//
//            guard let firUser = result?.user else {return}
//            let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
//            //Upload to Firestore
//            self.createFirestoreUser(user: artUser)
//        }
        
        guard let authUser = Auth.auth().currentUser else {return}
        //credential(資格情報)
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        //承認されたプロパイダーを現在認証されているユーザーにリンクさせる
        //今回はメールによる資格情報に一連のキーを与えている
        authUser.link(with: credential) { (result, error) in
            //エラー処理
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            guard let firUser = result?.user else {return}
            let artUser = User.init(id: firUser.uid, email: email, username: username, stripeId: "")
            //Upload to Firestore
            self.createFirestoreUser(user: artUser)
            
        }
        
    }
    
    func createFirestoreUser(user: User) {
        // Step1 Create doucument reference
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        print("print newUserRef -> \(newUserRef)")
        // Step2 Create model data
        let data = User.modelToData(user: user)
        print("print user -> \(user)")
        print("print data -> \(data)")
        // Step3 Upload to Firestore
        newUserRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                debugPrint("Unable to upload new user Document in: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicater.stopAnimating()
        }
    }
    
    
    func fetchFbData() {
        linkFbBtn.setTitle("Unlink Facebook Account", for: .normal)
        let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"], httpMethod: HTTPMethod(rawValue: "GET"))
        request.start { (connection, result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            
            guard let dictionaly = result as? [String: Any] else {return}
            guard let firstName = dictionaly["first_name"] as? String,
                let lastName = dictionaly["last_name"] as? String,
                let email = dictionaly["email"] as? String else {return}
            
            guard let pictureObject = dictionaly["picture"] as? [String: Any],
                let pictureData = pictureObject["data"] as? [String: Any],
                let urlString = pictureData["url"] as? String else {return}
            
            let url = URL(string: urlString)
            let processor = RoundCornerImageProcessor(cornerRadius: 20)
            self.fbAvatar.kf.setImage(with: url, placeholder: nil, options: [.processor(processor), .transition(.fade(0.2))], progressBlock: nil, completionHandler: nil)
            
            self.emailTxt.text = email
            self.usernameTxt.text = firstName
        }
    }
    
    
    @IBAction func linkWithFbClicked(_ sender: Any) {
        if AccessToken.current != nil {
           
        } else {
            loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else if result?.isCancelled ?? true {
                    
                } else {
                    self.fetchFbData()
                }
            }
        }
    }
}
