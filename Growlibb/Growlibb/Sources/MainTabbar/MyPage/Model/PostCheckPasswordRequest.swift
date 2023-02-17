//
//  PostCheckPasswordRequest.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/17.
//

import Foundation

struct PostCheckPasswordRequest: Encodable {
    var phoneNumber, email: String
}
