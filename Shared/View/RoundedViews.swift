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
        layer.cornerRadius = 4
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
