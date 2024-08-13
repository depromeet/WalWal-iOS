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
  
  func updateCenterLabels(with text: String, in detailView: UIView, window: UIWindow, burstMode: WalWalBurstString) {
    clearExistingLabels()
    
    let words = text.split(separator: " ")
    var lines: [[String]] = [[]]
    let labelFont = burstMode.font
    let windowWidth = window.bounds.width
    var currentLineWidth: CGFloat = 0
    
    for word in words {
      let wordWidth = calculateWordWidth(word, with: labelFont)
      if currentLineWidth + wordWidth > windowWidth {
        lines.append([String(word)])
        currentLineWidth = wordWidth
      } else {
        lines[lines.count - 1].append(String(word))
        currentLineWidth += wordWidth
      }
    }
    
    let countLabelY = detailView.center.y - 40
    var startY = countLabelY + 60
    
    for line in lines {
      let lineText = line.joined(separator: " ")
      addCharactersAsLabels(lineText, to: window, startY: &startY, detailView: detailView, labelFont: labelFont)
    }
  }
  
  func clearExistingLabels() {
    centerLabels.forEach { $0.removeFromSuperview() }
    centerShadowLabels.forEach { $0.removeFromSuperview() }
    centerLabels.removeAll()
    centerShadowLabels.removeAll()
  }
  
  private func calculateWordWidth(_ word: String.SubSequence, with font: UIFont) -> CGFloat {
    let testLabel = UILabel()
    testLabel.attributedText = NSAttributedString(string: String(word), attributes: [.font: font])
    testLabel.sizeToFit()
    return testLabel.bounds.width
  }
  
  private func addCharactersAsLabels(_ text: String, to window: UIWindow, startY: inout CGFloat, detailView: UIView, labelFont: UIFont) {
    let characters = Array(text)
    var delay: TimeInterval = 0
    var totalWidth: CGFloat = 0
    
    for char in characters {
      totalWidth += calculateCharacterWidth(char, with: labelFont)
    }
    
    var startX = detailView.center.x - totalWidth / 2
    
    for char in characters {
      addCharacterLabel(char, to: window, startX: &startX, startY: startY, detailView: detailView, labelFont: labelFont, delay: &delay)
    }
    
    startY += labelFont.lineHeight - (labelFont.lineHeight * 0.25)
  }
  
  private func calculateCharacterWidth(_ char: Character, with font: UIFont) -> CGFloat {
    let testLabel = UILabel()
    testLabel.attributedText = NSAttributedString(string: String(char), attributes: [.font: font])
    testLabel.sizeToFit()
    return testLabel.bounds.width
  }
  
  private func addCharacterLabel(_ char: Character, to window: UIWindow, startX: inout CGFloat, startY: CGFloat, detailView: UIView, labelFont: UIFont, delay: inout TimeInterval) {
    let shadowLabel = createShadowLabel(for: char, font: labelFont)
    let label = createCharacterLabel(for: char, font: labelFont)
    
    centerLabels.append(label)
    centerShadowLabels.append(shadowLabel)
    
    let initialY = startY + window.bounds.height / 2
    shadowLabel.center = CGPoint(x: startX + shadowLabel.bounds.width / 2 + 4, y: initialY + 4)
    label.center = CGPoint(x: startX + label.bounds.width / 2, y: initialY)
    startX += label.bounds.width
    
    window.addSubview(shadowLabel)
    window.addSubview(label)
    
    UIView.animate(withDuration: 0.5, delay: delay, options: [], animations: {
      shadowLabel.alpha = 1
      shadowLabel.center.y = startY + 4
      label.alpha = 1
      label.center.y = startY
    }, completion: nil)
    
    delay += 0.1
  }
  
  private func createShadowLabel(for char: Character, font: UIFont) -> UILabel {
    let shadowLabel = UILabel()
    let shadowAttrString = NSAttributedString(
      string: String(char),
      attributes: [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.black,
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
        .strokeColor: ResourceKitAsset.Colors.black.color,
        .font: font,
        .foregroundColor: ResourceKitAsset.Colors.white.color,
        .strokeWidth: -4
      ]
    )
    label.attributedText = attrString
    label.textAlignment = .center
    label.sizeToFit()
    label.alpha = 0
    return label
  }
}
