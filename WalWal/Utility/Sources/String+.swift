//
//  String+.swift
//  Utility
//
//  Created by Jiyeon on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

public extension String {
  func isValidNickName() -> Bool {
    let nicknameRegex = "^[가-힣A-Za-z0-9]+$"
    return NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
          .evaluate(with: self)
  }
  
  /// 날짜 형식 변환 YYYY-MM-DD -> YYYY년 MM월 DD일
  func toFormattedDate() -> String? {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      guard let date = dateFormatter.date(from: self) else {
          return nil
      }
      dateFormatter.dateFormat = "yyyy년 M월 d일"
      return dateFormatter.string(from: date)
  }
  
  /// 현재 시간 기준 날짜 형식 변환 프로퍼티
  ///
  /// - parameters:
  ///   - format: 변환 전 날짜 형식
  ///   - to: 변환하려는 날짜 형식
  ///
  /// ### 사용 예시
  /// ```swift
  /// "2024-09-03T09:00:01.402789".formattedRelativeDate(
  /// format: .fullISO8601,
  /// to: .yearMonthDayDots
  /// )
  /// ```
  /// - 1시간 미만의 차이면 '-분 전'
  /// - 24시간 미만의 차이면 '-시간 전'
  /// - 24시간 이상의 차이면 '24.09.03'
  func formattedRelativeDate(format: DateFormat, to type: DateFormat) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.rawValue
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    
    guard let date = dateFormatter.date(from: self) else {
      return ""
    }
    
    let currentDate = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents(
      [.hour, .minute],
      from: date,
      to: currentDate
    )
    
    if let hoursDifference = components.hour,
        let minutesDifference = components.minute {
      if hoursDifference < 1 {
        if minutesDifference < 1 {
          return "방금 전"
        } else {
          return "\(minutesDifference)분 전"
        }
      } else if hoursDifference < 24 {
        return "\(hoursDifference)시간 전"
      } else {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = type.rawValue
        return outputFormatter.string(from: date)
      }
    } else {
      return ""
    }
  }
  
  func isWithin24Hours(format: DateFormat) -> Bool {
    // DateFormatter 생성
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.rawValue
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    
    // 문자열을 Date 객체로 변환
    guard let date = dateFormatter.date(from: self) else {
      return false
    }
    
    // 현재 시간과 비교
    let currentDate = Date()
    let timeInterval = currentDate.timeIntervalSince(date)
    
    // 24시간(86400초) 이내인지 확인
    return timeInterval <= 86400
  }
}

/// 날짜 변환 형식
public enum DateFormat: String {
  case fullISO8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
  case yearMonthDayDots = "yy.MM.dd"
}
