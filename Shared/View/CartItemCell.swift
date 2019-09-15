//
//  CartItemCell.swift
//  Aretct
//
//  Created by yw on 2019/09/05.
//  Copyright © 2019 yw. All rights reserved.
//

import UIKit

protocol CartItemDelegate : class {
    func removeItem(product: Product)
}

class CartItemCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var productImg: RoundImageView!
    @IBOutlet weak var productTitleLbl: UILabel!
    @IBOutlet weak var removeItemBtn: UIButton!
    
    // Variables
    private var item: Product!
    weak var delegate : CartItemDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(product: Product, delegate: CartItemDelegate) {
        self.delegate = delegate
        self.item = product
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if let price = formatter.string(from: product.price as NSNumber) {
            productTitleLbl.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageUrl) {
            productImg.kf.setImage(with: url)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeItemClicked(_ sender: Any) {
        delegate?.removeItem(product: item)
    }
}
