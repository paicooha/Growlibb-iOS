//
//  GetRetrospectListResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/18.
//

import Foundation

struct GetRetrospectListResponse: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: GetRetrospectResult?
}

// MARK: - Result
struct GetRetrospectResult: Codable {
    var retrospections: [Retrospection]
}

// MARK: - Retrospection
struct Retrospection: Codable {
    var id: Int
    var writtenDate: String
}
