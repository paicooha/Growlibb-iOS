//
//  PostLoginRequest.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation

struct LoginRequest: Encodable {
    var email: String
    var password: String
}
