//
//  Profile.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/27.
//

import Foundation

// MARK: - GetRetrospectTabResponse
struct GetMyProfileResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: MyProfile
}

// MARK: - Result
struct MyProfile: Decodable {
    var userID: Int
    var nickname, email, phoneNumber, birthday: String
    var gender, job: String
    var profileImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, email, phoneNumber, birthday, gender, job, profileImageUrl
    }
}
