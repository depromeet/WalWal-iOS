//
//  WalWalChip.swift
//  DesignSystem
//
//  Created by 조용인 on 8/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift
import RxCocoa
import FlexLayout
import PinLayout
import Then

public class WalWalChip: UIView {
  
  public enum ChipStyle {
    case filled
    case outlined
    case tonal
  }
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  fileprivate let label = UILabel().then {
    $0.textAlignment = .center
    $0.font = ResourceKitFontFamily.KR.B2
  }
  
  // MARK: - Properties
  
  private let cornerRadius: CGFloat
  private let size: CGSize
  
  // MARK: - Initializers
  
  /// WalWalChip을 초기화합니다.
  /// - Parameters:
  ///   - text: 초기 Chip의 타이틀 입니다
  ///   - size: Chip의 사이즈 입니다. (default: 64x28)
  ///   - style: Chip의 스타일 입니다.
  public init(
    text: String? = nil,
    size: CGSize = CGSize(width: 64, height: 28),
    style: ChipStyle
  ) {
    self.cornerRadius = size.height / 2
    self.size = size
    super.init(frame: .zero)
    configureLayout()
    configureStyle(style: style)
    configureText(text: text)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycles
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin
      .all()
    containerView.flex
      .layout()
    
    configureAttributes()
  }
  
  // MARK: - Methods
  
  private func configureAttributes() {
    layer.cornerRadius = cornerRadius
    clipsToBounds = true
  }
  
  private func configureLayout() {
    addSubview(containerView)
    
    containerView.flex
      .alignItems(.center)
      .justifyContent(.center)
      .define { flex in
      flex.addItem(label)
          .size(size)
    }
  }
  
  fileprivate func configureStyle(style: ChipStyle) {
    switch style {
    case .filled:
      backgroundColor = ResourceKitAsset.Colors.gray900.color
      label.textColor = ResourceKitAsset.Colors.white.color
      layer.borderWidth = 0
    case .outlined:
      backgroundColor = ResourceKitAsset.Colors.white.color
      label.textColor = ResourceKitAsset.Colors.gray900.color
      layer.borderWidth = 1
      layer.borderColor = ResourceKitAsset.Colors.gray150.color.cgColor
    case .tonal:
      backgroundColor = ResourceKitAsset.Colors.gray150.color
      label.textColor = ResourceKitAsset.Colors.gray600.color
      layer.borderWidth = 0
    }
  }
  
  fileprivate func configureText(text: String?) {
    label.text = text
  }
}

// MARK: - Reactive Extension

extension Reactive where Base: WalWalChip {
  
  public var text: Binder<String?> {
    return Binder(base) { chip, text in
      chip.configureText(text: text)
    }
  }
  
  public var style: Binder<WalWalChip.ChipStyle> {
    return Binder(base) { chip, style in
      chip.configureStyle(style: style)
    }
  }
}
