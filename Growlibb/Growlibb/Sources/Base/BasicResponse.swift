//
//  BasicResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/24.
//

import Foundation
import SwiftyJSON

struct BasicResponse {
    let isSuccess: Bool
    let code: Int
    let message: String

    init(json: JSON?) throws {
        guard let json = json,
              let success = json["isSuccess"].bool,
              let code = json["code"].int,
              let message = json["message"].string
        else { throw JSONError.error("Json Decoding Error") }
        isSuccess = success
        self.code = code
        self.message = message
    }
}
