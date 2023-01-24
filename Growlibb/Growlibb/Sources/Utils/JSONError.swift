//
//  JSONError.swift
//  Growlibb
//
//  Created by 이유리 on 2023/01/24.
//

import Foundation

enum JSONError: Error {
    case error(String)
}

extension JSONError {
    static var decoding: JSONError {
        .error("JSON Decoding Error")
    }

    static var toJson: JSONError {
        .error("Data to JSON Error")
    }
}
