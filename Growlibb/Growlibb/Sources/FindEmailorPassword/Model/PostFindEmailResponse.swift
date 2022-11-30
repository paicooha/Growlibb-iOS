//
//  PostFindEmailResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/30.
//

import Foundation

// MARK: - PostFindEmailResponse
struct PostFindEmailResponse: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: PostFindEmailResult
}

// MARK: - Result
struct PostFindEmailResult: Codable {
    var email: String
}
