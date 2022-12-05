//
//  GetHomeResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2022/12/02.
//

import Foundation

// MARK: - GetHomeResponse
struct GetHomeResponse: Codable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: GetHomeResult?
}

// MARK: - Result
struct GetHomeResult: Codable {
    var retrospectionDates: [String]
    var latestRetrospectionInfos: [LatestRetrospectionInfo]
}

// MARK: - LatestRetrospectionInfo
struct LatestRetrospectionInfo: Codable {
    var id: Int
    var writtenDate: String
}
