//
//  EditRetrospectConfig.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/19.
//

import Foundation
import RxDataSources

struct EditRetrospectConfig: Equatable, IdentifiableType {
    
    let id: Int
    let text: String
    var deletionStatus: String? = nil

    init(attempt: Attempt) {
        id = attempt.id ?? -1
        text = attempt.content
        deletionStatus = attempt.deletionStatus
    }
    
    var identity: String {
        "\(id)"
    }
}
