//
//  UILabel+.swift
//  DesignSystem
//
//  Created by 이지희 on 8/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public extension UILabel {
  var visibleTextLength: Int {
    guard let myText = self.text else { return 0 }
    
    let font = self.font ?? UIFont.systemFont(ofSize: 12, weight: .medium)
    let labelWidth = self.frame.size.width
    let labelHeight = self.frame.size.height
    let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .kern: 0
    ]
    
    var index = 0
    var prevIndex = 0
    
    while index < myText.count {
      prevIndex = index
      let substring = (myText as NSString).substring(to: index + 1)
      let boundingRect = (substring as NSString).boundingRect(with: sizeConstraint, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
      if boundingRect.height > labelHeight {
        break
      }
      index += 1
    }
    return prevIndex
  }
  
  func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
    guard let myText = self.text else { return }
    
    let convertedTrailingText = trailingText.replacingOccurrences(of: "...", with: "…")
    var trimmedString = (myText as NSString).substring(to: self.visibleTextLength)
    
    let readMoreLength = convertedTrailingText.count + moreText.count
    let spaceWidth = " ".size(withAttributes: [.font: self.font!]).width
    var numberOfSpaces = trimmedString.filter { $0 == " " }.count
    let totalSpaceWidth = CGFloat(numberOfSpaces) * spaceWidth
    let trimmedStringWidth = (trimmedString as NSString).boundingRect(
      with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.frame.height),
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      attributes: [.font: self.font!],
      context: nil
    ).width
    
    if trimmedString.last == " " {
      trimmedString.removeLast()
      numberOfSpaces -= 1
    }
    
    // Calculate effective removal length considering space widths
    let effectiveRemovalLength = readMoreLength + Int(totalSpaceWidth / spaceWidth)
    
    if trimmedString.count <= effectiveRemovalLength { return }
    
    var adjustedLength = trimmedString.count - effectiveRemovalLength
    if totalSpaceWidth > 0 {
      adjustedLength = max(0, trimmedString.count - effectiveRemovalLength + numberOfSpaces)
    }
    
    var trimmedForReadMore = (trimmedString as NSString).substring(to: adjustedLength)
    
    trimmedForReadMore += convertedTrailingText
    
    let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [.font: self.font as Any])
    let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [.font: moreTextFont, .foregroundColor: moreTextColor])
    
    answerAttributed.append(readMoreAttributed)
    self.attributedText = answerAttributed
  }
  
  
  /// 폰트 변경 함수
  func asFont(targetString: String, font: UIFont) {
    let fullText = text ?? ""
    let attributedString = NSMutableAttributedString(string: fullText)
    let range = (fullText as NSString).range(of: targetString)
    attributedString.addAttribute(.font, value: font, range: range)
    attributedText = attributedString
  }
  
  /// 색상 변경 함수
  func asColor(targetString: String, color: UIColor) {
    let fullText = text ?? ""
    let attributedString = NSMutableAttributedString(string: fullText)
    let range = (fullText as NSString).range(of: targetString)
    attributedString.addAttribute(.foregroundColor, value: color, range: range)
    attributedText = attributedString
  }
  
  /// 라벨 줄 수 계산 함수
  ///
  /// 사용 예시
  /// ```
  /// let label = UILabel()
  /// label.text = "여러 줄이 있는 텍스트"
  /// let numberOfLines = label.lineNumber(forWidth: 200)
  /// ```
  func lineNumber(forWidth labelWidth: CGFloat) -> Int {
    guard let text = self.text else { return 0 }
    let boundingRect = text.boundingRect(with: .zero, options: [.usesFontLeading],
                                         attributes: [.font: self.font ?? UIFont.systemFont(ofSize: 14)], context: nil)
    return Int(boundingRect.width / labelWidth + 1)
  }
}
