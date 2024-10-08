//
//  FeedMenuListView.swift
//  FeedPresenterImp
//
//  Created by Jiyeon on 10/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import RxSwift

final class FeedMenuListView: UIView {
  
  private typealias Fonts = ResourceKitFontFamily
  private typealias Colors = ResourceKitAsset.Colors
  
  private let rootContainer = UIView().then {
    $0.backgroundColor = Colors.white.color
  }
  private let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  private let titleLabel = CustomLabel(font: Fonts.KR.H7.B).then {
    $0.textColor = Colors.gray900.color
  }
  
  // MARK: - Initialize
  
  public init(title: String, icon: UIImage) {
    super.init(frame: .zero)
    self.titleLabel.text = title
    self.iconImageView.image = icon
    configLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainer.pin.all()
    rootContainer.flex.layout(mode: .adjustHeight)
  }
  
  private func configLayout() {
    addSubview(rootContainer)
    
    rootContainer.flex
      .direction(.row)
      .justifyContent(.start)
      .alignItems(.center)
      .height(48.adjustedHeight)
      .define {
        $0.addItem(iconImageView)
          .size(24.adjusted)
        $0.addItem(titleLabel)
          .marginLeft(6.adjustedWidth)
          .grow(1)
        
      }
  }
}
