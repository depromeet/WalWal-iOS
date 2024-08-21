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
  private var completedAnimationsCount = 0

  func updateCenterLabels(
    with text: String,
    in detailView: UIView,
    window: UIWindow,
    completion: (() -> Void)? = nil
  ) {
    clearExistingLabels()
    
    let labelFont = WalWalBurstString.font
    let words = text.split(separator: " ")
    let availableWidth = window.bounds.width - (2 * sideMargin)
    let lines = calculateLines(for: words, with: labelFont, maxWidth: availableWidth)
    let totalCharacters = lines.flatMap { $0 }.joined().count
    completedAnimationsCount = 0 // 초기화
    
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
        
        let delay = Double(lineIndex * lineText.count + charIndex) * 0.1
        animateLabel(label, shadowLabel: shadowLabel, delay: delay) {
          self.completedAnimationsCount += 1
          if self.completedAnimationsCount == totalCharacters {
            completion?() // 모든 애니메이션이 완료되면 completion 호출
          }
        }
        
        startX += label.bounds.width - characterOverlap
      }
      
      startY += (labelFont.lineHeight - 30)
    }
  }
  
  func disappearLabels(completion: (() -> Void)? = nil) {
    let delayBetweenChars: TimeInterval = 0.1
    var completionCount = 0
    
    for (index, (label, shadowLabel)) in zip(centerLabels, centerShadowLabels).enumerated() {
      let delay = Double(index) * delayBetweenChars
      animateLabelDisappearance(label, shadowLabel: shadowLabel, delay: delay) {
        completionCount += 1
        if completionCount == self.centerLabels.count {
          self.clearExistingLabels()
          completion?() // 모든 애니메이션이 완료된 후에 completion 호출
        }
      }
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
  
  private func animateLabel(_ label: UILabel, shadowLabel: UILabel, delay: TimeInterval, completion: @escaping () -> Void) {
    /// 초기 상태 설정
    label.alpha = 1
    shadowLabel.alpha = 1
    label.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    shadowLabel.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    
    /// 랜덤 시작 각도 (-15도에서 15도 사이)
    let startAngle = [CGFloat.pi / 8, -CGFloat.pi / 8].randomElement() ?? CGFloat.pi / 8
    
    UIView.animateKeyframes(withDuration: 0.5, delay: delay, options: [], animations: {
      
      /// 크기 애니메이션 (팝업 효과)
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
        label.transform = CGAffineTransform(scaleX: 1, y: 1).rotated(by: startAngle)
        shadowLabel.transform = CGAffineTransform(scaleX: 1, y: 1).rotated(by: startAngle)
      }
      
      /// 크기 정상화 및 흔들림 애니메이션
      UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
        label.transform = CGAffineTransform(scaleX: 1, y: 1).rotated(by: 0)
        shadowLabel.transform = CGAffineTransform(scaleX: 1, y: 1).rotated(by: 0)
      }
    }, completion: { _ in
      // 흔들림 애니메이션 추가
      self.addExpandAndWobbleAnimation(to: label)
      self.addExpandAndWobbleAnimation(to: shadowLabel)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        completion()
      }
    })
  }
  
  /// 등장 후 102%로 확장 및 흔들림 애니메이션 추가
  private func addExpandAndWobbleAnimation(to label: UILabel) {
    UIView.animate(withDuration: 0.3, animations: {
      // 글자 크기를 102%로 살짝 확장
      label.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
    })
  }
  
  private func animateLabelDisappearance(_ label: UILabel, shadowLabel: UILabel, delay: TimeInterval, completion: @escaping () -> Void) {
    /// 초기 상태 설정
    label.alpha = 1
    shadowLabel.alpha = 1
    label.transform = .identity
    shadowLabel.transform = .identity
    
    /// 랜덤 시작 각도 (-15도에서 15도 사이)
    let startAngle = [CGFloat.pi / 8, -CGFloat.pi / 8].randomElement() ?? CGFloat.pi / 8
    
    UIView.animateKeyframes(withDuration: 0.5, delay: delay, options: [], animations: {
      // 첫 번째 키프레임: 약간 커지면서 회전 시작
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
        let transform = CGAffineTransform(scaleX: 1.1, y: 1.1).rotated(by: startAngle / 2)
        label.transform = transform
        shadowLabel.transform = transform
      }
      
      // 두 번째 키프레임: 작아지면서 완전히 회전하고 투명해짐
      UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
        let transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: startAngle)
        label.transform = transform
        shadowLabel.transform = transform
        label.alpha = 0
        shadowLabel.alpha = 0
      }
    }) { _ in
      label.transform = .identity
      shadowLabel.transform = .identity
      label.alpha = 0
      shadowLabel.alpha = 0
      completion()
    }
  }
  
  private func removeSwingTransform(to view: UIView, endAngle: CGFloat) {
    view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0).rotated(by: endAngle)
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
