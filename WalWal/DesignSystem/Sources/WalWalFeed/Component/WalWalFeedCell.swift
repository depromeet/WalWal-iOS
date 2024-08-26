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
  public private(set) var feedView = WalWalFeedCellView()
  static let identifier = "WalWalFeedCell"
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setAttributes()
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
    feedView.maxLength = 55
    feedView.isContentExpanded = false 
    feedView.contentLabel.numberOfLines = 2
  }
  
  // MARK: - Methods
  
  func configureCell(feedData: WalWalFeedModel) {
    feedView.configureFeed(feedData: feedData)
    contentView.backgroundColor = .clear
    
    feedView.layoutSubviews()
    
    feedView.flex
      .markDirty()
    
    layoutCell()
    
    invalidateIntrinsicContentSize()
  }
  
  private func setAttributes() {
    contentView.addSubview(feedView)
  }
  
  private func layoutCell() {
    feedView.pin
      .all()
    
    feedView.flex
      .layout(mode: .adjustHeight)
    
    contentView.flex
      .layout(mode: .adjustHeight)
    
  }
}
