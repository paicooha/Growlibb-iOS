//
//  PatchResetPasswordRequest.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/30.
//

import Foundation

struct PatchResetPasswordRequest: Encodable {
    var phoneNumber: String
    var email: String
    var password: String
    var confirmPassword: String
}
