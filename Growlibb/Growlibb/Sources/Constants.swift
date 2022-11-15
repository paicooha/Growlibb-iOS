//
//  Constants.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/04.
//

import Alamofire

struct Constants {
    // MARK: Network
    static let BASE_URL = "http://3.229.102.197/"
    
    var loginKeyChainService: LoginKeyChainService
    var token:String

    var HEADERS: HTTPHeaders {
        ["x-access-token": token]
    }

    init() {
        loginKeyChainService = BasicLoginKeyChainService.shared
        token = loginKeyChainService.token?.jwt ?? ""
    }
}
