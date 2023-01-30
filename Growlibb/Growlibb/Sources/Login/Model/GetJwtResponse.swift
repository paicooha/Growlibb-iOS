//
//  GetJwtResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

// MARK: - GetJwtResponse
struct GetJwtResponse: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: GetJwtResult?
}

// MARK: - Result
struct GetJwtResult: Codable {
    var jwt: String
    var userID: Int
    var email, phoneNumber, nickname: String
    var seedLevel: Int
    var notificationStatus: String

    enum CodingKeys: String, CodingKey {
        case jwt
        case userID = "userId"
        case email, phoneNumber, nickname, seedLevel, notificationStatus
    }
}
