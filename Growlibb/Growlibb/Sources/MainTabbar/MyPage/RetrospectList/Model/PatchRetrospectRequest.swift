//
//  PatchRetrospectRequest.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/19.
//

import Foundation
import RxDataSources

// MARK: - PatchRetrospectRequest
struct PatchRetrospectRequest: Encodable {
    var id: Int
    var done, keep, problem, attempt: [RetrospectItem]
}

// MARK: - Attempt
struct RetrospectItem: Encodable {
    var id: Int?
    var content: String
    var deletionStatus: String?
}
