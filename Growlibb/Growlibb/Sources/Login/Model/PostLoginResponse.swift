//
//  PostLoginResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation

// MARK: - PostLoginResponse
struct PostLoginResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: PostLoginResult?
}

// MARK: - Result
struct PostLoginResult: Codable {
    let jwt: String
    let userId: Int
    let email, phoneNumber, nickname: String
}
