//
//  FeedHeaderView.swift
//  DesignSystem
//
//  Created by 이지희 on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

final class FeedHeaderView: UICollectionReusableView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  static let identifier = "FeedHeaderView"
  
  private let guideLabel = UILabel().then {
    $0.font = Fonts.KR.H6.B
    $0.textColor = .black
    $0.text = "☀️ 다른 반려동물은 어떤 미션을 했을까요?"
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureLayout() {
    addSubview(guideLabel)
    
    guideLabel.pin
      .center()
      .sizeToFit()
  }
}
