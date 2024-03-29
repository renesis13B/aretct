//
//  User.swift
//  Aretct
//
//  Created by yw on 2019/08/30.
//  Copyright © 2019 yw. All rights reserved.
//

import Foundation

struct User : Codable {
    var id: String
    var email: String
    var username: String
    var stripeId: String
    
    var avatarUrl: String = ""
    var hasSetupAccount: Bool = false
    var isGuest: Bool = false
    
    
    init(id: String = "",
         email: String = "",
         username: String = "",
         stripeId: String = "") {
        
        self.id = id
        self.email = email
        self.username = username
        self.stripeId = stripeId
    }
    
    init(data: [String: Any]) {
        id = data["id"] as? String ?? ""
        email = data["email"] as? String ?? ""
        username = data["username"] as? String ?? ""
        stripeId = data["stripeId"] as? String ?? ""
    }
    
    static func modelToData(user: User) -> [String: Any] {
        
        let data : [String: Any] = [
            "id" : user.id,
            "email" : user.email,
            "username" : user.username,
            "stripeId" : user.stripeId
        ]
        
        return data
    }
}
