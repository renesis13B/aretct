//
//  ViewController.swift
//  AretctAdmin
//
//  Created by yw on 2019/08/19.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit

class AdminHomeVC: HomeVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.isEnabled = false
        //ボタンの初期化
        let addCategoryBtn = UIBarButtonItem(title: "Add Category", style: .plain, target: self
            , action: #selector(addCategory))
        
        //初期化したボタンを設定
        navigationItem.rightBarButtonItem = addCategoryBtn
    }
    
    @objc func addCategory() {
        performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
    }
}

