//
//  WalWalBoostCenterLabel.swift
//  DesignSystem
//
//  Created by 조용인 on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

final class WalWalBoostCenterLabel {
  
  private typealias Colors = ResourceKitAsset.Colors
  
  private var centerLabels: [UILabel] = []
  private var centerShadowLabels: [UILabel] = []
  
  private let letterSpacing: CGFloat = -1.0 // 음수 값으로 글자 간격을 좁힘
  private let sideMargin: CGFloat = 20.0
  private let characterOverlap: CGFloat = 8.0 // 글자 간 겹침 정도
  
  func updateCenterLabels(
    with text: String,
    in detailView: UIView,
    window: UIWindow,
    burstMode: WalWalBurstString
  ) {
    clearExistingLabels()
    
    let labelFont = burstMode.font
    let words = text.split(separator: " ")
    let availableWidth = window.bounds.width - (2 * sideMargin)
    let lines = calculateLines(for: words, with: labelFont, maxWidth: availableWidth)
    
    let countLabelY = detailView.center.y - 40
    var startY = countLabelY + 60
    
    for (lineIndex, line) in lines.enumerated() {
      let lineText = line.joined(separator: " ")
      let totalWidth = calculateLineWidth(lineText, with: labelFont, considering: characterOverlap)
      var startX = (window.bounds.width - totalWidth) / 2
      
      for (charIndex, char) in lineText.enumerated() {
        if char == " " {
          startX += calculateLineWidth(" ", with: labelFont, considering: characterOverlap)
          continue
        }
        
        let (label, shadowLabel) = createCharacterLabels(for: char, font: labelFont)
        centerLabels.append(label)
        centerShadowLabels.append(shadowLabel)
        
        label.center = CGPoint(x: startX + label.bounds.width / 2, y: startY)
        shadowLabel.center = CGPoint(x: startX + shadowLabel.bounds.width / 2 + 4, y: startY + 4)
        
        window.addSubview(shadowLabel)
        window.addSubview(label)
        
        let delay = Double(lineIndex * lineText.count + charIndex) * 0.05
        animateLabel(label, shadowLabel: shadowLabel, delay: delay)
        
        startX += label.bounds.width - characterOverlap
      }
      
      startY += (labelFont.lineHeight - 30)
    }
  }
  
  private func calculateLines(for words: [String.SubSequence], with font: UIFont, maxWidth: CGFloat) -> [[String]] {
    var lines: [[String]] = [[]]
    var currentLineWidth: CGFloat = 0
    
    for word in words {
      let wordWidth = calculateLineWidth(String(word), with: font, considering: characterOverlap)
      if currentLineWidth + wordWidth > maxWidth {
        if !lines[lines.count - 1].isEmpty {
          lines.append([String(word)])
          currentLineWidth = wordWidth
        } else {
          lines[lines.count - 1].append(String(word))
          lines.append([])
          currentLineWidth = 0
        }
      } else {
        if !lines[lines.count - 1].isEmpty {
          currentLineWidth += calculateLineWidth(" ", with: font, considering: characterOverlap)
        }
        lines[lines.count - 1].append(String(word))
        currentLineWidth += wordWidth
      }
    }
    
    return lines.filter { !$0.isEmpty }
  }
  
  private func calculateLineWidth(_ text: String, with font: UIFont, considering overlap: CGFloat) -> CGFloat {
    let attributes = [NSAttributedString.Key.font: font]
    let width = (text as NSString).size(withAttributes: attributes).width
    return width - (CGFloat(text.count - 1) * overlap)
  }
  
  private func createCharacterLabels(for char: Character, font: UIFont) -> (UILabel, UILabel) {
    let label = createCharacterLabel(for: char, font: font)
    let shadowLabel = createShadowLabel(for: char, font: font)
    return (label, shadowLabel)
  }
  
  private func animateLabel(_ label: UILabel, shadowLabel: UILabel, delay: TimeInterval) {
    /// 초기 상태 설정
    label.alpha = 0
    shadowLabel.alpha = 0
    label.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    shadowLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    
    /// 랜덤 시작 각도 (-15도에서 15도 사이)
    let startAngle = CGFloat.random(in: -CGFloat.pi/12...CGFloat.pi/12)
    
    UIView.animateKeyframes(withDuration: 0.6, delay: delay, options: [], animations: {
      /// 알파값 애니메이션
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
        label.alpha = 1
        shadowLabel.alpha = 1
      }
      
      /// 크기 애니메이션 (팝업 효과)
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
        label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).rotated(by: startAngle)
        shadowLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).rotated(by: startAngle)
      }
      
      /// 크기 정상화 및 흔들림 애니메이션
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
        self.applySwingTransform(to: label, startAngle: startAngle, progress: 1)
        self.applySwingTransform(to: shadowLabel, startAngle: startAngle, progress: 1)
      }
    })
  }
  
  private func applySwingTransform(to view: UIView, startAngle: CGFloat, progress: Double) {
    let swingAngle = startAngle * (1 - CGFloat(progress))
    view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).rotated(by: swingAngle)
  }
  
  func clearExistingLabels() {
    centerLabels.forEach { $0.removeFromSuperview() }
    centerShadowLabels.forEach { $0.removeFromSuperview() }
    centerLabels.removeAll()
    centerShadowLabels.removeAll()
  }
  
  private func createShadowLabel(for char: Character, font: UIFont) -> UILabel {
    let shadowLabel = UILabel()
    let shadowAttrString = NSAttributedString(
      string: String(char),
      attributes: [
        .strokeColor: Colors.black.color,
        .foregroundColor: Colors.black.color,
        .strokeWidth: -4,
        .font: font
      ]
    )
    shadowLabel.attributedText = shadowAttrString
    shadowLabel.textAlignment = .center
    shadowLabel.sizeToFit()
    shadowLabel.alpha = 0
    return shadowLabel
  }
  
  private func createCharacterLabel(for char: Character, font: UIFont) -> UILabel {
    let label = UILabel()
    let attrString = NSAttributedString(
      string: String(char),
      attributes: [
        .strokeColor: Colors.black.color,
        .font: font,
        .foregroundColor: Colors.white.color,
        .strokeWidth: -6
      ]
    )
    label.attributedText = attrString
    label.textAlignment = .center
    label.sizeToFit()
    label.alpha = 0
    return label
  }
}
