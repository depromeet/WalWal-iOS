//
//  DateFormatter.swift
//  Utility
//
//  Created by Eddy on 6/26/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public enum DateFormatType {
    /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
    case isoDate
    /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mm" i.e. 1997-07-16T19:20
    case isoDateTime
    /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ss" i.e. 1997-07-16T19:20:30
    case isoDateTimeSec
    /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
    case isoDateTimeMilliSec

    public var string: String {
        switch self {
        case .isoDate:
            return "yyyy-MM-dd"
        case .isoDateTime:
            return "yyyy-MM-dd'T'HH:mm"
        case .isoDateTimeSec:
            return "yyyy-MM-dd'T'HH:mm:ss"
        case .isoDateTimeMilliSec:
            return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        }
    }
}

public extension Date {
    static func formatter(with format: DateFormatType) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format.string
        formatter.locale = Locale(identifier: "ko")
        return formatter
    }
    
    /// Date 타입을 String으로 바꿀때 사용하는 메서드
    /// ex) Date().string(format: .isoDate)
    func toString(format: DateFormatType) -> String {
        return Date.formatter(with: format).string(from: self)
    }
}

public extension String {
    /// String 타입을 Date으로 바꿀때 사용하는 메서드
    /// "2024.11.22".date(format: .isoDate)
    func toDate(format: DateFormatType) -> Date? {
        return Date.formatter(with: format).date(from: self)
    }
}
