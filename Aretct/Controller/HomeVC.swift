//
//  ViewController.swift
//  Aretct
//
//  Created by yw on 2019/08/19.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    //Outlets
    @IBOutlet weak var loginOutBtn: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        //viewDidLoadはviewのインスタンス時に一度だけ呼ばれる
        //対照的にviewDidAppearはロードするたびに表示される
        if let _ = Auth.auth().currentUser {
            loginOutBtn.title = "Logout"
        } else {
            loginOutBtn.title = "Login"
        }
    }
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        //storyboardの初期viewcontrollerを初期化する
        let contoroller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(contoroller, animated: true, completion: nil)
    }

    @IBAction func loginOutClicked(_ sender: Any) {
        if let _ = Auth.auth().currentUser {
            do {
                try Auth.auth().signOut()
                presentLoginController()
            } catch {
                debugPrint(error.localizedDescription)
            }
        } else {
            presentLoginController()
        }
    }
    
}

