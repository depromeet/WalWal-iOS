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

public final class WalWalFeedCell: UICollectionViewCell {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - Components
  public private(set) var feedView = WalWalFeedCellView()
  static let identifier = "WalWalFeedCell"
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setAttributes()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is not implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    setNeedsLayout()
    layoutIfNeeded()
    
    let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
    var frame = layoutAttributes.frame
    frame.size.height = ceil(size.height)
    layoutAttributes.frame = frame
    
    return layoutAttributes
  }
  
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    layoutCell()
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
    feedView.isExpanded = false
    feedView.contentLabel.numberOfLines = 2
  }
  
  // MARK: - Methods
  
  func configureCell(feedData: WalWalFeedModel) {
    feedView.configureFeed(feedData: feedData)
    contentView.backgroundColor = .clear
    
    feedView.moreTapped
      .subscribe(onNext: { [weak self] isExpanded in
        guard let self = self else { return }
        self.feedView.isExpanded = true
        
        if let collectionView = superview as? UICollectionView {
          collectionView.collectionViewLayout.invalidateLayout()
        }
        self.setNeedsLayout()
      })
      .disposed(by: disposeBag)
    
    
    feedView.layoutSubviews()
    
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
