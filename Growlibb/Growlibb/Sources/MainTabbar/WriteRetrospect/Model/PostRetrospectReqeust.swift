//
//  PostRetrospectReqeust.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/01.
//

import Foundation

struct PostRetrospectRequest: Encodable {
    var done, keep, problem, attempt: [String]
}

struct PostRetrospectResponse: Codable {
    let result: PostRetrospectResult?
}

struct PostRetrospectResult: Codable {
    var retrospectionID, seedLevel, point: Int
    var eventTitle: String?
    var eventCondition: Int
    var eventScore: Int

    enum CodingKeys: String, CodingKey {
        case retrospectionID = "retrospectionId"
        case seedLevel, point, eventTitle, eventCondition, eventScore
    }
}
