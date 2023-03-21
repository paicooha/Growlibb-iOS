//
//  RetrospectAPI.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/24.
//

import Foundation
import Moya

enum RetrospectAPI {
    case getRetrospectTab(token: LoginToken)
}

extension RetrospectAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case .getRetrospectTab:
            return "/v1/retrospection"
            
        }
    }

    var method: Moya.Method {
        switch self {
        case .getRetrospectTab:
            return Method.get
        }
    }

    var task: Task {
        switch self {
        case .getRetrospectTab:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var header = ["x-access-token": ""]
        switch self {

        case let .getRetrospectTab(token):
            header["x-access-token"] = "\(token.jwt)"

        }
        return header
    }
}
