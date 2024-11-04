//
//  Constants.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 11/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import Utility
import ResourceKit

enum Const {
  private typealias Fonts = ResourceKitFontFamily
  
  private static var isTouchIDCapableDevice: Bool = Device.isTouchIDCapableDevice
  
  // MARK: MissionCompleteView
  static let topMargin = isTouchIDCapableDevice ? 32.adjustedSE : 39.adjusted
  static let containerHeight = isTouchIDCapableDevice ? 336.adjustedSE : 476.adjusted
  static let itemSize = isTouchIDCapableDevice ? CGSize(width: 180.adjustedWidthSE, height: 296.adjustedHeightSE) : CGSize(width: 255.adjusted, height: 436.adjusted)
  static let itemSpacing = isTouchIDCapableDevice ? 20.adjustedSE : 30.adjusted
  static let spacingRatio: CGFloat = isTouchIDCapableDevice ? (153/180) : (216/255)
  static let completeLabelFont = isTouchIDCapableDevice ? Fonts.KR.H7.B.withSize(14.adjustedSE) : Fonts.KR.H6.B
  
  static var insetX: CGFloat {
    (UIScreen.main.bounds.width - Self.itemSize.width) / 2.0
  }
  
  static var collectionViewContentInset: UIEdgeInsets {
    UIEdgeInsets(top: 0, left: Self.insetX, bottom: 0, right: Self.insetX)
  }
  
  static var buttonHeight = isTouchIDCapableDevice ? 40.adjustedWidthSE : 50.adjusted
  
  // MARK: RecordCarouselCell
  static let lineHeight: CGFloat = isTouchIDCapableDevice ? 29.adjustedHeightSE : 30.adjusted
  static let enterSpace: CGFloat = isTouchIDCapableDevice ? 14.adjustedSE : 14.adjusted
  static let numberOfLines: Int = isTouchIDCapableDevice ? 3 : 4
  static let swapButtonSize = isTouchIDCapableDevice ? 30.adjustedSE : 30.adjusted
  static let dateChipHeight = isTouchIDCapableDevice ? 30.adjustedHeightSE : 30.adjusted
  static let bottomMargin = isTouchIDCapableDevice ? 10.adjustedHeightSE : 10.adjusted
  
  static let todayMissionFont = isTouchIDCapableDevice ? Fonts.KR.H9.withSize(10.adjustedSE) : Fonts.KR.H7.B
  static let missionTitleFont = isTouchIDCapableDevice ? Fonts.KR.H7.B.withSize(14.adjustedSE) : Fonts.KR.H4
  
  // MARK: BubbleView
  static let verticalPadding = isTouchIDCapableDevice ? 10.adjustedSE : 8.5.adjusted
  static let iconSize = isTouchIDCapableDevice ? 18.adjustedSE : 18.adjusted
  static let tipHeight = isTouchIDCapableDevice ? 14.adjustedSE : 14.adjusted
}
