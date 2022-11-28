//
//  PostSignUpResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/24.
//

import Foundation

// MARK: - PostSignUpResponse
struct PostSignUpResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: PostSignUpResult
}

// MARK: - Result
struct PostSignUpResult: Codable {
    let jwt: String
    let userID: Int
    let email, phoneNumber, nickname: String
    let seedLevel, point: Int
    let notificationStatus: String

    enum CodingKeys: String, CodingKey {
        case jwt
        case userID = "userId"
        case email, phoneNumber, nickname, seedLevel, point, notificationStatus
    }
}
