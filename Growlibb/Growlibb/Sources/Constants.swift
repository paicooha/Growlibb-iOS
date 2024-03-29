//
//  Constants.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/04.
//

import Alamofire

struct Constants {
    static let shared = Constants()
    
    var loginKeyChainService: LoginKeyChainService

    var HEADERS: HTTPHeaders {
        ["x-access-token": loginKeyChainService.token?.jwt ?? ""]
    }

    init() {
        loginKeyChainService = BasicLoginKeyChainService.shared
    }
}
