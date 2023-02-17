//
//  DateUtil.swift
//  Growlibb
//
//  Created by 이유리 on 2022/12/03.
//

import Foundation

enum DateFormat {
    case yyyyMMddKR
    case yyyyMddKR
    case yyyyMKR
    case yyMMdd
    case yyyyMDash
    case yyyyMddDash
}

extension DateFormat {
    var formatString: String {
        switch self {
        case .yyyyMMddKR:
            return "yyyy년 MM월 dd일"
        case .yyyyMddKR:
            return "yyyy년 M월 dd일"
        case .yyyyMKR:
            return "yyyy년 M월"
        case .yyMMdd:
            return "yy.MM.dd"
        case .yyyyMDash:
            return "yyyy-MM"
        case .yyyyMddDash:
            return "yyyy-MM-dd"
        }
    }
}
