//
//  Constants.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/04.
//

import Alamofire

struct Constants {
    // MARK: Network
    static let BASE_URL = "https://dev.growlibb.co.kr/"
//    static let BASE_URL = "https://prod.growlibb.co.kr/"
    static let shared = Constants()
    
    var loginKeyChainService: LoginKeyChainService

    var HEADERS: HTTPHeaders {
        ["x-access-token": loginKeyChainService.token?.jwt ?? ""]
    }

    init() {
        loginKeyChainService = BasicLoginKeyChainService.shared
    }
}
