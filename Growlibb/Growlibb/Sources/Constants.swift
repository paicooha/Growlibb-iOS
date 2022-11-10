//
//  Constants.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/04.
//

import Alamofire

struct Constants {
    // MARK: Network
    static let BASE_URL = "https://www.atflee-admin.com"

    static var HEADERS: HTTPHeaders {
        return [
            "Content-Type": "application/json",
//            "X-ACCESS-TOKEN": UserManager.shared.jwt
        ]
    }
}
