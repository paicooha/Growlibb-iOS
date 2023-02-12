//
//  BaseAPI.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/24.
//

import Foundation

enum BaseAPI {
    static var url = URL(string: "http://43.200.160.196")!
}

enum APIResult<T> {
    case response(result: T)
    case error(alertMessage: String?)
}
