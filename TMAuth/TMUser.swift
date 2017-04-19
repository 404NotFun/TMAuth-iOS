//
//  TMUser.swift
//  Food Yom
//
//  Created by Jason Tsai on 2016/12/25.
//  Copyright © 2016年 FN404. All rights reserved.
//

import Foundation
import ObjectMapper

class TMUser: Mappable {
    // 基本資訊
    var id = String()
    var nickname = String()
    var identity = String()
    var location_id = String()
    var department = String()
    var grade = String()
    var favorites = [Int]()
    var gender = Int()
    var level = Int()
    var exp = Int()
    // 會員資訊
    var username = String()
    var password = String()
    var email = String()
    var profilePhotoUrl = String()
    var backgroundPhotoUrl = String()
    var fbId = String()
    var gId = String()
    //其他
    var createdAt = String()
    var updatedAt = String()
    var token = String()
    var confirmCode = String()
    var providedCount = Int()
    var activityMsg = String()
    
    required init?(map: Map) {
        
    }
    
    init(username: String, password: String, email: String, confirmCode: String) {
        self.username = username
        self.password = password
        self.email = email
        self.confirmCode = confirmCode
    }
    
    func setUserData(identity: String, location_id: String, department: String, grade: String, favorites: [Int]) {
        self.identity = identity
        self.location_id = location_id
        self.department = department
        self.grade = grade
        self.favorites = favorites
    }
    
    func mapping(map: Map) {
        var temp = String()
        self.id             <- map["id"]
        self.username       <- map["username"]
        self.nickname       <- map["nickname"]
        self.email          <- map["email"]
        self.identity       <- map["identity"]
        self.location_id    <- map["location"]
        self.department     <- map["department"]
        temp                <- map["favorites"]
        let tempAry          = temp.characters.split{$0 == ","}.map(String.init)
        self.favorites       = tempAry.map{Int($0)!}
        self.grade          <- map["grade"]
        temp                <- map["gender"]
        self.gender          = Int(temp)!
        temp                <- map["exp"]
        self.exp             = Int(temp)!
        self.createdAt      <- map["created_at"]
        self.updatedAt      <- map["updated_at"]
        self.token          <- map["token"]
        self.fbId           <- map["fb_id"]
        self.gId           <- map["g_id"]
        self.profilePhotoUrl <- map["profile_photo_url"]
        self.backgroundPhotoUrl <- map["background_photo_url"]
        self.confirmCode    <- map["confirm_code"]
        temp                <- map["provided_count"]
        self.providedCount   = Int(temp)!
        self.activityMsg    <- map["activity_msg"]
    }
}
