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
}
