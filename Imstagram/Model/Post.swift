//
//  Post.swift
//  Imstagram
//
//  Created by MacBook AIR on 02/10/2023.
//

import Foundation


struct Post {
    var post:String
    var user:User
    var caption:String
    var creationDate:Date
    init(post: [String:Any],user:User) {
        self.post = post["imageUrl"] as? String ?? ""
        self.user = user
        self.caption = post["caption"] as? String ?? ""
        let secondsFrom1970 = post["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
  
    
    
}

struct User {
    var username:String
    var userImage:String
    var uid: String
    init(user: [String:Any],uid:String) {
        self.username = user["username"] as? String ?? ""
        self.userImage = user["profileImageUrl"] as? String ?? ""
        self.uid = uid
    }
}

