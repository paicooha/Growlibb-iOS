//
//  PatchPasswordRequest.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/17.
//

import Foundation

struct PatchPasswordRequest: Encodable {
    var phoneNumber, email, password, confirmPassword: String
}
