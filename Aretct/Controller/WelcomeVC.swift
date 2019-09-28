//
//  WelcomeVC.swift
//  Aretct
//
//  Created by yw on 2019/09/28.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginClicked(_ sender: Any) {
        performSegue(withIdentifier: Segues.ToLoginVC, sender: self)
    }
    
    @IBAction func toRegisterClicked(_ sender: Any) {
    }
    
    @IBAction func guestClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
