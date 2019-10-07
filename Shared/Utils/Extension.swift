//
//  Extension.swift
//  Aretct
//
//  Created by yw on 2019/08/23.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit
import Firebase

extension String {
    var isNotEmpty : Bool {
        return !isEmpty
    }
}

extension UIViewController {
    
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Int {
    
    func penniesToFormattedCurrency() -> String {
        let price = Double(self) / 1
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ja_JP")
        
        if let price = formatter.string(from: price as NSNumber) {
            return price
        }
        
        return "¥0"
    }
}
