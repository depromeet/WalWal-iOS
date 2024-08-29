//
//  UnderlinedTextView.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/29/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

public class UnderlinedTextView: UITextView {
  
  /// 밑줄 간격
  private let underLineHeight: CGFloat = 40
  /// 엔터 눌렀을 때 텍스트 간의 간격
  private let enterSpacing: CGFloat = 21
  /// 밑줄 최대 라인 수
  private let numberOfMaxLines: Int
  
  private let fontStyle: UIFont
  private let foregroundColor: UIColor
  private let underLineColor: CGColor
  private let walwalColor: UIColor
  
  public init(
    font: UIFont,
    textColor: UIColor,
    tintColor: UIColor,
    underLineColor: UIColor,
    numberOfLines: Int
  ) {
    self.fontStyle = font
    self.foregroundColor = textColor
    self.underLineColor = underLineColor.cgColor
    self.walwalColor = tintColor
    self.numberOfMaxLines = numberOfLines
    super.init(frame: .zero, textContainer: nil)
    self.font = font
    self.tintColor = tintColor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// AttributedText 속성 설정 메서드
  public func attributeText() {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = enterSpacing
    
    // 속성 텍스트 설정
    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: paragraphStyle,
      .font: fontStyle,
      .foregroundColor: foregroundColor
    ]
    let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
    
    // 왈왈
    let walwalAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: walwalColor
    ]
    if let range = text.range(of: "왈왈") {
      let nsRange = NSRange(range, in: text)
      attributedString.addAttributes(walwalAttributes, range: nsRange)
    }
    
    if let range = text.range(of: "WalWal") {
      let nsRange = NSRange(range, in: text)
      attributedString.addAttributes(walwalAttributes, range: nsRange)
    }
    
    // UITextView에 속성 텍스트 할당
    self.attributedText = attributedString
    self.typingAttributes[.paragraphStyle] = paragraphStyle
  }
  
  public override func caretRect(for position: UITextPosition) -> CGRect {
    var superRect = super.caretRect(for: position)
    guard let font = self.font else { return superRect }
    
    superRect.size.height = font.pointSize - font.descender
    return superRect
  }
  
  /// 밑줄 그리기
  public override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.setStrokeColor(underLineColor)
    context.setLineWidth(1.0)
    
    let lineSpacing: CGFloat = 0
    let fontLineHeight: CGFloat = self.font?.lineHeight ?? 0
    
    var currentBaseline = self.textContainerInset.top + self.textContainer.lineFragmentPadding + underLineHeight - fontLineHeight - 10
    
    
    
    for _ in 0..<numberOfMaxLines {
      let underlineY = currentBaseline + fontLineHeight
      context.move(
        to: CGPoint(
          x: self.textContainerInset.left,
          y: underlineY
        )
      )
      context.addLine(
        to: CGPoint(
          x: rect.width - self.textContainerInset.right,
          y: underlineY
        )
      )
      context.strokePath()
      currentBaseline += underLineHeight + lineSpacing
    }
  }
}
