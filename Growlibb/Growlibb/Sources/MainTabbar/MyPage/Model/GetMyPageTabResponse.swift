//
//  GetMyPageTabResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation

// MARK: - GetRetrospectTabResponse
struct GetMyPageTabResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: MyPage
}

// MARK: - Result
struct MyPage: Decodable {
    var nickname, email: String
    var profileImageUrl: String?
    var seedLevel, point, retrospectionCount: Int
}
