//
//  Constants.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 11/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

enum Const {
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: MissionCompleteView
  static let topMargin = UIDevice.isSESizeDevice ? 32.adjustedSE : 14.adjusted
  static let containerHeight = UIDevice.isSESizeDevice ? 336.adjustedSE : 476.adjusted
  static let itemSize = UIDevice.isSESizeDevice ? CGSize(width: 180.adjustedWidthSE, height: 296.adjustedHeightSE) : CGSize(width: 255.adjusted, height: 436.adjusted)
  static let itemSpacing = UIDevice.isSESizeDevice ? 20.adjustedSE : 30.adjusted
  static let spacingRatio: CGFloat = UIDevice.isSESizeDevice ? (153/180) : (216/255)
  static let completeLabelFont = UIDevice.isSESizeDevice ? Fonts.KR.H7.B.withSize(14.adjustedSE) : Fonts.KR.H6.B
  
  static var insetX: CGFloat {
    (UIScreen.main.bounds.width - Self.itemSize.width) / 2.0
  }
  
  static var collectionViewContentInset: UIEdgeInsets {
    UIEdgeInsets(top: 0, left: Self.insetX, bottom: 0, right: Self.insetX)
  }
  
  static var buttonHeight = UIDevice.isSESizeDevice ? 40.adjustedWidthSE : 50.adjusted
  
  // MARK: RecordCarouselCell
  static let lineHeight: CGFloat = UIDevice.isSESizeDevice ? 29.adjustedHeightSE : 30.adjusted
  static let enterSpace: CGFloat = UIDevice.isSESizeDevice ? 14.adjustedSE : 14.adjusted
  static let numberOfLines: Int = UIDevice.isSESizeDevice ? 3 : 4
  static let swapButtonSize = UIDevice.isSESizeDevice ? 30.adjustedSE : 30.adjusted
  static let dateChipHeight = UIDevice.isSESizeDevice ? 30.adjustedHeightSE : 30.adjusted
  static let bottomMargin = UIDevice.isSESizeDevice ? 10.adjustedHeightSE : 10.adjusted
  
  static let todayMissionFont = UIDevice.isSESizeDevice ? Fonts.KR.H9.withSize(10.adjustedSE) : Fonts.KR.H7.B
  static let missionTitleFont = UIDevice.isSESizeDevice ? Fonts.KR.H7.B.withSize(14.adjustedSE) : Fonts.KR.H4
  
  // MARK: BubbleView
  static let verticalPadding = UIDevice.isSESizeDevice ? 10.adjustedSE : 8.5.adjusted
  static let iconSize = UIDevice.isSESizeDevice ? 18.adjustedSE : 18.adjusted
  static let tipHeight = UIDevice.isSESizeDevice ? 14.adjustedSE : 14.adjusted
}
