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
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - Components
  private let feedView = WalWalFeedCellView()
  static let identifier = "WalWalFeedCell"
  
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
    layoutCell()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    layoutCell()
  }
  
  // MARK: - Methods
  
  func configureCell(feedData: WalWalFeedModel) {
    feedView.configureFeed(feedData: feedData)
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
  
  private func layoutCell() {
    feedView.pin
      .all()
    feedView.flex
      .layout()
  }
}
