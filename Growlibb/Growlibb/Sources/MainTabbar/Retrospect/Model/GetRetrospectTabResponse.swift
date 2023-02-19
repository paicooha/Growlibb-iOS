//
//  GetRetrospectTabResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/24.
//

import Foundation

// MARK: - GetRetrospectTabResponse
struct GetRetrospectTabResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: RetrospectInfo
}

// MARK: - Result
struct RetrospectInfo: Decodable {
    var point, needPointForLevel, continuousWritingCount, needContinuousRetrospection: Int
    var gender: String
    var todayWrittenRetrospectionId: Int
}
