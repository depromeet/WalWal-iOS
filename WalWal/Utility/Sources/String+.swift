//
//  String+.swift
//  Utility
//
//  Created by Jiyeon on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

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
  
  /// 주어진 폰트와 너비에 맞춰 텍스트가 몇 줄에 표시될지 계산하는 메서드
  func lineNumber(forWidth width: CGFloat, font: UIFont) -> Int {
    let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let textRect = self.boundingRect(with: maxSize,
                                     options: [.usesLineFragmentOrigin, .usesFontLeading],
                                     attributes: [.font: font],
                                     context: nil)
    let lineHeight = font.lineHeight
    let numberOfLines = Int(ceil(textRect.height / lineHeight))
    
    return numberOfLines
  }
}
