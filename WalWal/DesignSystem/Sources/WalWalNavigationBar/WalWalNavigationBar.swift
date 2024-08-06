//
//  WalWalNavigationBar.swift
//  DesignSystem
//
//  Created by 조용인 on 7/29/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import FlexLayout
import PinLayout
import RxSwift


public final class WalWalNavigationBar: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let containerView = UIView()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.black.color
    label.textAlignment = .center
    label.font = Fonts.KR.H4
    return label
  }()
  
  
  // MARK: - Properties
  
  public private(set) var leftItems: [WalWalTouchArea]?
  public private(set) var rightItems: [WalWalTouchArea]?
  public private(set) var colorType: NavigationBarColorSet
  
  // MARK: - Initializers
  
  
  /// leftItems와 rightItems에 좌우측에 들어갈 item을 정의합니다.
  /// WalWalNavigationBar.leftItems[n].rx.tapped으로 이벤트를 받아올 수 있습니다.
  /// - Parameters:
  ///   - leftItems: 네비게이션바의 왼쪽에 위치 할 item들을 정의합니다. (없는 경우는 .none)
  ///   - leftItemSize: 네비게이션바의 왼쪽에 위치 할 item들의 사이즈를 정의합니다. (default: 24)
  ///   - title: 네비게이션바의 중앙에 오는 Title을 정의합니다.
  ///   - rightItems: 네비게이션바의 오른쪽에 위치 할 item들을 정의합니다. (없는 경우는 .none)
  ///   - rightItemSize: 네비게이션바의 오른쪽에 위치 할 item들의 사이즈를 정의합니다. (defautl: 24)
  ///   - colorType: 네비게이션의 전체 BackgroundColor와 TintColor를 정의합니다.
  public init(
    leftItems: [NavigationBarItemType],
    leftItemSize: CGFloat = 24,
    title: String?,
    rightItems: [NavigationBarItemType],
    rightItemSize: CGFloat = 24,
    colorType: NavigationBarColorSet = .normal
  ) {
    self.leftItems = leftItems.map { WalWalTouchArea(image: $0.icon, size: leftItemSize) }
    self.rightItems = rightItems.map { WalWalTouchArea(image: $0.icon, size: rightItemSize) }
    self.colorType = colorType
    
    super.init(frame: .zero)
    
    self.configureTitle(title)
    self.configureLayout()
    self.configureColor()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("can not init from coder")
  }
  
  // MARK: - Lifecycle
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    self.containerView.pin.all()
    self.containerView.flex.layout()
  }
  
  // MARK: - Methods
  
  public func configure(
    leftItems: [NavigationBarItemType],
    leftItemSize: CGFloat = 24,
    title: String?,
    rightItems: [NavigationBarItemType],
    rightItemSize: CGFloat = 24,
    colorType: NavigationBarColorSet = .normal
  ) {
    self.leftItems = leftItems.map { WalWalTouchArea(image: $0.icon, size: leftItemSize) }
    self.rightItems = rightItems.map { WalWalTouchArea(image: $0.icon, size: rightItemSize) }
    self.colorType = colorType
    
    self.configureTitle(title)
    self.configureLayout()
    self.configureColor()
  }
}

// MARK: - Private Methods

extension WalWalNavigationBar {
  
  private func configureContainerView() {
    self.containerView.clipsToBounds = true
  }
  
  private func configureTitle(_ title: String?) {
    self.titleLabel.text = title
  }
  
  private func configureLayout() {
    self.addSubview(containerView)
    
    self.containerView.flex
      .height(50)
      .direction(.row)
      .alignItems(.center)
      .backgroundColor(colorType.backgroundColor)
      .define { flex in
        flex.addItem()
          .direction(.row)
          .width(80)
          .justifyContent(.start)
          .define { flex in
            self.leftItems?.forEach { item in
              flex.addItem(item)
                .marginRight(16)
            }
          }
          .marginLeft(15)
        
        flex.addItem(self.titleLabel)
          .grow(1)
          .shrink(1)
          .alignSelf(.center)
        
        flex.addItem()
          .direction(.row)
          .width(80)
          .justifyContent(.end)
          .define { flex in
            self.rightItems?.forEach {
              flex.addItem($0)
                .marginLeft(16)
            }
          }
          .marginRight(20)
      }
  }
  
  private func configureColor() {
    titleLabel.textColor = colorType.tintColor
    
    leftItems?.forEach { $0.backgroundColor = self.colorType.backgroundColor }
    rightItems?.forEach { $0.backgroundColor = self.colorType.backgroundColor }
    titleLabel.backgroundColor = colorType.backgroundColor
    self.backgroundColor = colorType.backgroundColor
  }
}
