//
//  Constants.swift
//  Aretct
//
//  Created by yw on 2019/08/23.
//  Copyright © 2019 yw. All rights reserved.
//

import Foundation
import  UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
    static let Main = "Main"
}


struct StoryboardId {
    static let LoginVC = "loginVC"
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
    static let FilledStar = "filled_star"
    static let EmptyStar = "empty_star"
    static let FilledHeart = "filled_heart"
    static let EmptyHeart = "empty_heart"
    static let Placeholder = "placeholder"
}

struct AppColors {
    static let Green = #colorLiteral(red: 0, green: 0.768627451, blue: 0.6470588235, alpha: 1)
    static let Gray = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let ProductCell = "ProductCell"
    static let CartItemCell = "CartItemCell"
}

struct Segues {
    static let ToProducts = "ToProductsVC"
    static let ToAddEditCategory = "ToAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
    static let ToFavorites = "ToFavorites"
    static let ToRegisterAccount = "ToRegisterAccount"
    static let ToLoginVC = "ToLoginVC"
}

struct AleartMessage {
    static let PleaseResisterUser = "これは会員限定の機能です。全ての機能を使うためには会員登録をお願いします"
    static let FileAllTextField = "すべての項目を記入して下さい"
}
