//
//  CustomLabel.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/25/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

public final class CustomLabel: UILabel {
  
  public override var text: String? {
    didSet {
      configureSpacing(text: text, font: self.font, lineBreakMode: lineBreakMode)
    }
  }
  
  public init(text: String? = "", font: UIFont, lineBreakMode: NSLineBreakMode = .byWordWrapping) {
    super.init(frame: .zero)
    self.text = text
    self.font = font
    self.lineBreakMode = lineBreakMode
    configureSpacing(text: text, font: font, lineBreakMode: lineBreakMode)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension UILabel {
  /// 줄간격
  func configureSpacing(text: String?, font: UIFont, lineBreakMode: NSLineBreakMode = .byWordWrapping) {
    let lineHeight = ResourceKitFontFamily.lineHeightPercent(of: font)
    let spacing = ResourceKitFontFamily.spacingPercent(of: font) * font.pointSize / 100

    if let text = text {
      let style = NSMutableParagraphStyle()
      style.alignment = self.textAlignment
      style.lineSpacing = 1
      style.lineBreakMode = lineBreakMode
      
      if let lineHeight = lineHeight {
        let lineHeight = font.pointSize * (lineHeight / 100)
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
      } else {
        style.minimumLineHeight = font.lineHeight
        style.maximumLineHeight = font.lineHeight
      }
      
      let attributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: style,
        .font: font,
        .kern: spacing
      ]
      let attrString = NSAttributedString(string: text,
                                          attributes: attributes)
      self.attributedText = attrString
      self.layoutIfNeeded()
    }
  }
}
