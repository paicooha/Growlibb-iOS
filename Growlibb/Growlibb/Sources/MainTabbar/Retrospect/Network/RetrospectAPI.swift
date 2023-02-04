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
//    case detail(postId: Int, userId: Int, token: LoginToken)
//
//
//    case apply(postId: Int, userId: Int, token: LoginToken)
//    case accept(postId: Int, userId: Int, applicantId: Int, accept: Bool, token: LoginToken)
//    case close(postId: Int, token: LoginToken)
//    case delete(postId: Int, userId: Int, token: LoginToken)
//
//    case myPage(userId: Int, token: LoginToken)
//    case attendance(postId: Int, userId: Int, token: LoginToken)
//
//    /// postings/:postId/report/:userId
//    case report(postId: Int, userId: Int, token: LoginToken)
}

extension RetrospectAPI: TargetType {
    var baseURL: URL {
        return BaseAPI.url
    }

    var path: String {
        switch self {
        case .getRetrospectTab:
            return "/v1/retrospection"
            
//        case let .detail(postId, userId, _):
//            return "/postings/v2/\(postId)/\(userId)"
//        case let .apply(postId, userId, _):
//            return "/runnings/request/\(postId)/\(userId)"
//        case let .accept(postId, _, applicantId, accept, _):
//            return "/runnings/request/\(postId)/handling/\(applicantId)/\(accept ? "Y" : "D")"
//        case let .close(postId, _):
//            return "/postings/\(postId)/closing"
//        case let .delete(postId, userId, _):
//            return "/postings/\(postId)/\(userId)/drop"
//        case let .myPage(userId, _):
//            return "/users/\(userId)/myPage/v2"
//        case let .attendance(postId, userId, _):
//            return "/runnings/\(postId)/attendees/\(userId)"
//        case let .report(postId, userId, _):
//            return "/postings/\(postId)/report/\(userId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getRetrospectTab:
            return Method.get
//        case .detail:
//            return Method.get
//        case .apply:
//            return Method.post
//        case .accept:
//            return Method.patch
//        case .close:
//            return Method.post
//        case .delete:
//            return Method.patch
//        case .myPage:
//            return Method.get
//        case .attendance:
//            return Method.patch
//        case .report:
//            return Method.post
        }
    }

    var task: Task {
        switch self {
        case .getRetrospectTab:
            return .requestPlain
//        case .detail:
//            return .requestPlain
//        case let .apply(_, userId, _):
//            return .requestPlain
//        case let .accept(_, userId, _, _, _):
            ////            let query: [String: Any] = [
            ////                "userId": userId,
            ////            ]
            ////            return .requestCompositeData(bodyData: Data(), urlParameters: query)
//            return .requestPlain
//        case .close:
//            return .requestPlain
//        case .delete:
//            return .requestPlain
//        case .myPage:
//            return .requestPlain
//        case .attendance:
//            return .requestPlain
//        case .report:
//            return .requestPlain
        }
    }

    var headers: [String: String]? {
        var header = ["x-access-token": ""]
        switch self {
//        case .fetch:
//            return nil
//        case let .posting(_, _, token):
//            header["x-access-token"] = "\(token.jwt)"
//        case let .bookmarking(_, _, _, token):
//            header["x-access-token"] = "\(token.jwt)"
        case let .getRetrospectTab(token):
            header["x-access-token"] = "\(token.jwt)"
//        case let .detail(_, _, token):
//            header["x-access-token"] = "\(token.jwt)"
//        case let .apply(_, _, token):
//            header["x-access-token"] = "\(token.jwt)"
//        case let .accept(_, _, _, _, token):
//            header["x-access-token"] = "\(token.jwt)"
//        case let .close(_, token):
//            header["x-access-token"] = "\(token.jwt)"
//        case let .delete(_, _, token):
//            header["x-access-token"] = "\(token.jwt)"
//        case let .myPage(_, token):
//            header["x-access-token"] = "\(token.jwt)"
//        case let .attendance(_, _, token):
//            header["x-access-token"] = "\(token.jwt)"
//        case let .report(_, _, token):
//            header["x-access-token"] = "\(token.jwt)"
        }
        return header
    }
}