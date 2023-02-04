//
//  WriteRetrospectAPI.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/01.
//

import Foundation
import Moya

enum WriteRetrospectAPI {
    case postRetrospect(request: PostRetrospectRequest, token: LoginToken)
}

extension WriteRetrospectAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case .postRetrospect:
            return "/retrospection/v1"
        }
    }

    var method: Moya.Method {
        switch self {
        case .postRetrospect:
            return Method.post
        }
    }

    var task: Task {
        switch self {
        case let .postRetrospect(request, _):
            return .requestJSONEncodable(request)
        }
    }

    var headers: [String: String]? {
        var header = ["x-access-token": "", "type":"iOS"]
        switch self {
        case let .postRetrospect(_, token):
            header["x-access-token"] = "\(token.jwt)"
        }
        return header
    }
}
