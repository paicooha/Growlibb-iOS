//
//  BaseAPI.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/24.
//

import Foundation

enum BaseAPI {
    static let url = URL(string: Secret.Moya_BASE_URL)!
}

enum APIResult<T> {
    case response(result: T)
    case error(alertMessage: String?)
}
