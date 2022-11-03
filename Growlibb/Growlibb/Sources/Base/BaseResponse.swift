//
//  BaseResponse.swift
//  Growlibb
//
//  Created by 이유리 on 2022/11/02.
//

import Foundation

struct BaseResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
}
