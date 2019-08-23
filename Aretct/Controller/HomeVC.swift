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
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    debugPrint(error)
                }
            }
        }
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        //viewDidLoadはviewのインスタンス時に一度だけ呼ばれる
        //対照的にviewDidAppearはロードするたびに表示される
        if let user = Auth.auth().currentUser, !user.isAnonymous {
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
        
        guard let user = Auth.auth().currentUser else {return}
        if user.isAnonymous {
            //匿名ログインの場合、実際にはFirebaseセッションからログアウトさせないため
            //匿名ログインはログインしたままにする
            presentLoginController()
        } else {
            //匿名ログイン以外でログアウトボタンを押した場合
            do{
                try Auth.auth().signOut()
                //ログアウト後に、匿名ログイン状態に戻す必要があるから
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        debugPrint(error)
                    }
                    self.presentLoginController()
                    
                }
            } catch{
                debugPrint(error)
            }
        }
    }
    
}

