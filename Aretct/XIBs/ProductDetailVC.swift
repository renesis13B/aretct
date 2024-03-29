//
//  ProductDetailVC.swift
//  Aretct
//
//  Created by yw on 2019/08/26.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController {

    //Outlets
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var bgView: UIVisualEffectView!
    
    // Variables
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productTitle.text = product.name
        productDescription.text = product.productDescription.replacingOccurrences(of: "\n", with: "\n")
        
        if let url = URL(string: product.imageUrl) {
            productImg.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ja_JP")
        if let price = formatter.string(from: product.price as NSNumber) {
            productPrice.text = price
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct(_:)))
        tap.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(tap)
    }
    
    @objc func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addCartClicked(_ sender: Any) {
        if UserService.isGuest {
            self.simpleAlert(title: "お客様へ", msg: AleartMessage.PleaseResisterUser)
            return
        }
       StripeCart.addItemToCart(item: product)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func dismissProduct(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    }
}
