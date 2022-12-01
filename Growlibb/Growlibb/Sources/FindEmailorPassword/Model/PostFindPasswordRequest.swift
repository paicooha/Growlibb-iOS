//
//  PostFindPasswordRequest.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/30.
//

import Foundation

struct PostFindPasswordRequest: Encodable {
    var phoneNumber: String
    var email: String
}
