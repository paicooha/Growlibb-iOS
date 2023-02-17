//
//  MyPageAPI.swift
//  Growlibb
//
//  Created by 이유리 on 2023/02/05.
//

import Foundation
import Moya

enum MyPageAPI {
    case getMyPage(token: LoginToken)
    case patchAlarm(request: PatchFcmRequest, token: LoginToken)
    case patchPhone(request: PostCheckPhoneRequest, token: LoginToken)
    case logout(token: LoginToken)
    case postCheckPassword(request: PostCheckPasswordRequest)
    case patchPassword(request: PatchPasswordRequest)
    case resign(request: ResignReason, token: LoginToken)
    case getRetrospectList(page:Int, token:LoginToken)
}

extension MyPageAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case .getMyPage:
            return "/v1/profile"
        case .patchAlarm:
            return "/v1/fcm-token"
        case .patchPhone:
            return "/auth/v1/phone-number"
        case .logout:
            return "/auth/v1/logout"
        case .postCheckPassword:
            return "/auth/v1/check-password"
        case .patchPassword:
            return "/auth/v1/password"
        case .resign:
            return "/auth/v1/status"
        case .getRetrospectList:
            return "/retrospection/v1"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getMyPage:
            return Method.get
        case .patchAlarm:
            return Method.patch
        case .patchPhone:
            return Method.patch
        case .logout:
            return Method.patch
        case .postCheckPassword:
            return Method.post
        case .patchPassword:
            return Method.patch
        case .resign:
            return Method.patch
        case .getRetrospectList:
            return Method.get
        }
    }

    var task: Task {
        switch self {
        case .getMyPage:
            return .requestPlain
        case let .patchAlarm(request, _):
            return .requestJSONEncodable(request)
        case let .patchPhone(request, _):
            return .requestJSONEncodable(request)
        case .logout:
            return .requestPlain
        case let .postCheckPassword(request):
            return .requestJSONEncodable(request)
        case let .patchPassword(request):
            return .requestJSONEncodable(request)
        case let .resign(request, _):
            return .requestJSONEncodable(request)
        case let .getRetrospectList(page, _):
            return .requestParameters(parameters: ["page":page, "size":20], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        var header = ["x-access-token": ""]
        switch self {
        case let .getMyPage(token):
            header["x-access-token"] = "\(token.jwt)"
        case let .patchAlarm(_, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .patchPhone(_, token):
            header["x-access-token"] = "\(token.jwt)"
        case let .logout(token):
            header["x-access-token"] = "\(token.jwt)"
        case let .resign(_, token: token):
            header["x-access-token"] = "\(token.jwt)"
        case .postCheckPassword:
            break
        case .patchPassword:
            break
        case let .getRetrospectList(_, token):
            header["x-access-token"] = "\(token.jwt)"
        }
        return header
    }
}
