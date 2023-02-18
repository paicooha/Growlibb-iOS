//
//  GetDetailRetrospectResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/18.
//

import Foundation

struct GetDetailRetrospectResponse: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: GetDetailRetrospectResult
}

// MARK: - Result
struct GetDetailRetrospectResult: Codable {
    var id: Int
    var writtenDate: String
    var done, keep, problem, attempt: [Attempt]
}

// MARK: - Attempt
struct Attempt: Codable {
    var id: Int
    var content: String
}
