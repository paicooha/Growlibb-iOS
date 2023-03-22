//
//  PostSignUpRequest.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/24.
//

import Foundation

struct PostSignUpRequest: Codable {
    let email, password, phoneNumber, nickname, fcmToken: String
    let gender, birthday, job: String?
}
