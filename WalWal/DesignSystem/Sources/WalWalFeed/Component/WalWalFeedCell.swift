//
//  WalWalFeedCell.swift
//  DesignSystem
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//
import UIKit
import ResourceKit

import Then
import FlexLayout
import PinLayout
import RxSwift

final class WalWalFeedCell: UICollectionViewCell {
  
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias FontEN = ResourceKitFontFamily.EN
  private typealias AssetColor = ResourceKitAsset.Colors
  private typealias AssetImage = ResourceKitAsset.Assets
  
  // MARK: - Components
  private let feedView = WalWalFeedCellView()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setAttributes()
    setLayouts()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is not implemented")
  }
  
  // MARK: - Lifecycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    feedView.pin
      .all()
    feedView.flex
      .layout()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    // Reset the cell’s state before it is reused.
  }
  
  // MARK: - Methods
  
  func configureCell(feedData: WalWalFeedModel) {
    feedView.ConfigureFeed(feedData: feedData)
  }
  
  private func setAttributes() {
    contentView.addSubview(feedView)
  }
  
  private func setLayouts() {
    contentView.flex
      .grow(1)
      .define {
        $0.addItem(feedView)
      }
  }
}
