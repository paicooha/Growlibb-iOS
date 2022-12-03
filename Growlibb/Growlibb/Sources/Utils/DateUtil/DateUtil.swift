//
//  DateUtil.swift
//  Growlibb
//
//  Created by 이유리 on 2022/12/03.
//

import Foundation

class DateUtil {
    static let shared = DateUtil()
    private init() {
        dateFormatter = DateFormatter()
    }

    let dateFormatter: DateFormatter

    var now: Date {
        return Date()
    }

    func getDate(from dateString: String, format: DateFormat) -> Date? {
        dateFormatter.dateFormat = format.formatString

        return dateFormatter.date(from: dateString)
    }

    func getCurrent(format: DateFormat) -> String {
        dateFormatter.dateFormat = format.formatString
        return dateFormatter.string(from: Date())
    }

    func formattedString(for date: Date, format: DateFormat, localeId: String = L10n.locale) -> String {
        let oldLocale = dateFormatter.locale
        defer { dateFormatter.locale = oldLocale }

        dateFormatter.locale = Locale(identifier: localeId)
        dateFormatter.dateFormat = format.formatString

        return dateFormatter.string(from: date)
    }
}
