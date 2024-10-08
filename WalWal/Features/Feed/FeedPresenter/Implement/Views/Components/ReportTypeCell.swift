//
//  ReportTypeCell.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout

final class ReportTypeCell: UITableViewCell, ReusableView  {
  
  private typealias Fonts = ResourceKitFontFamily
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Images = ResourceKitAsset.Images
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let cellItemContainer = UIView()
  private let separator = UIView().then {
    $0.backgroundColor = Colors.gray150.color
  }
  let titleLabel = CustomLabel(font: Fonts.KR.H7.M).then {
    $0.textColor = Colors.gray900.color
  }
  private let chevron = UIImageView().then {
    $0.image = Images.chevronRight.image
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: - Properties
  
  var isSeparatorHidden: Bool = false {
    didSet {
      separator.isHidden = isSeparatorHidden
    }
  }
  
  // MARK: - Initialize
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configAttribute()
    configLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin
      .all()
    cellItemContainer.flex
      .layout()
    rootContainer.flex
      .layout()
  }
  
  private func configAttribute() {
    contentView.backgroundColor = Colors.white.color
    contentView.addSubview(rootContainer)
  }
  
  private func configLayout() {
    rootContainer.flex
      .justifyContent(.spaceBetween)
      .define {
        $0.addItem(cellItemContainer)
          .width(100%)
          .grow(1)
        
        $0.addItem(separator)
          .width(100%)
          .height(1)
      }
    
    cellItemContainer.flex
      .direction(.row)
      .justifyContent(.spaceBetween)
      .alignItems(.center)
      .define {
        $0.addItem(titleLabel)
          .grow(1)
        $0.addItem(chevron)
          .size(28.adjusted)
      }
  }
}
