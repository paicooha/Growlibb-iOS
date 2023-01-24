//
//  BaseAPI.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/24.
//

import Foundation

enum BaseAPI {
    static var url = URL(string: "http://13.209.37.231")!
}

enum APIResult<T> {
    case response(result: T)
    case error(alertMessage: String?)
}
