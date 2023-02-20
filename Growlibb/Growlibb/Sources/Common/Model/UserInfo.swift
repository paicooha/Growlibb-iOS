//
//  UserInfo.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/24.
//

import Foundation

class UserInfo {
    static let shared = UserInfo()
    
    var userId:Int
    var email:String
    var password:String
    var phoneNumber:String
    var gender:String
    var nickName:String
    var birthday:String
    var job:String
    var fcmToken:String
    var profileUrl:String?
    
    init(){
        userId = 0
        email = ""
        password = ""
        phoneNumber = ""
        gender = "M"
        nickName = ""
        birthday = ""
        job = ""
        fcmToken = ""
        profileUrl = nil
    }
}
