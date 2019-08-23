//
//  ViewController.swift
//  Aretct
//
//  Created by yw on 2019/08/19.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    fileprivate func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        //storyboardの初期viewcontrollerを初期化する
        let contoroller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(contoroller, animated: true, completion: nil)
    }


}

