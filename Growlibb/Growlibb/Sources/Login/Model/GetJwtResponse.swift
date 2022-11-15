//
//  GetJwtResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/15.
//

import Foundation

// MARK: - Welcome
struct GetJwtResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: GetJwtResult
}

// MARK: - Result
struct GetJwtResult: Codable {
    let jwt: String
    let userId: Int
    let email, phoneNumber, nickname: String
}
