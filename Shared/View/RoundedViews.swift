//
//  RoundedViews.swift
//  Aretct
//
//  Created by yw on 2019/08/23.
//  Copyright © 2019 yw. All rights reserved.
//

//UI要素の視覚的なプロパティを設定する

import UIKit

class RoundedButton : UIButton {
    //クラスが初期化されるとすぐに呼び出されるメソッド
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.backgroundColor = UIColor(red: 1, green: 0.36, blue: 0.36, alpha: 1).cgColor
        layer.cornerRadius = 20
    }
}

class WhiteRoundedButton : UIButton {
    //クラスが初期化されるとすぐに呼び出されるメソッド
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 1, green: 0.36, blue: 0.36, alpha: 1).cgColor
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer.cornerRadius = 20
    }
}


class RoundedShadowView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        //UIColorをUICgcolorに変換
        layer.shadowColor = AppColors.Gray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
    }
}

class RoundImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}

class RoundImageTopLefAndBottomLefttView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        if #available(iOS 11.0, *) {
            layer.maskedCorners = [.layerMinXMinYCorner , .layerMinXMaxYCorner]
        } else {
            let path = UIBezierPath(roundedRect:self.bounds,
                                    byRoundingCorners:[.topRight, .bottomRight],
                                    cornerRadii: CGSize(width: 20, height: 20))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            layer.mask = maskLayer
        }
    }
}
