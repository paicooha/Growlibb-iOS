//
//  BaseAPI.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/24.
//

import Foundation

enum BaseAPI {
    static var url = URL(string: "https://dev.growlibb.co.kr")!
//    static var url = URL(string: "https://prod.growlibb.co.kr")!
}

enum APIResult<T> {
    case response(result: T)
    case error(alertMessage: String?)
}
