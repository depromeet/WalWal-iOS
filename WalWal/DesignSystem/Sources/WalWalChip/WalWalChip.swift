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
    case none /// 아무것도 없는 상태
    case date
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
  }
  
  // MARK: - Properties
  
  private let text: String?
  private let selectedText: String?
  private let style: ChipStyle
  private let selectedStyle: ChipStyle
  private let cornerRadius: CGFloat
  private let size: CGSize
  private let font: UIFont
  
  private let disposeBag = DisposeBag()
  fileprivate let isSelected = BehaviorRelay<Bool>(value: false)
  
  // MARK: - Initializers
  
  /// WalWalChip을 초기화합니다.
  /// - Parameters:
  ///   - text: 초기 Chip의 타이틀 입니다
  ///   - selectedText: 선택되었을 때의 Chip의 타이틀 입니다.
  ///   - size: Chip의 사이즈 입니다. (default: 64x28)
  ///   - style: Chip의 스타일 입니다.
  ///   - selectedStyle: 선택되었을 때의 Chip의 스타일 입니다. (default: .none)
  ///   - fond: Chip의 폰트 입니다. (default: ResourceKitFontFamily.KR.B2)
  public init(
    text: String? = nil,
    selectedText: String? = nil,
    style: ChipStyle,
    selectedStyle: ChipStyle = .none,
    size: CGSize = CGSize(width: 64, height: 28),
    font: UIFont = ResourceKitFontFamily.KR.B2
  ) {
    self.cornerRadius = size.height / 2
    self.size = size
    self.font = font
    self.text = text
    self.selectedText = selectedText == nil ? text : selectedText
    self.style = style
    self.selectedStyle = selectedStyle == .none ? style : selectedStyle
    super.init(frame: .zero)
    configureLayout()
    configureStyle(style: style)
    configureText(text: text)
    bind()
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
  
  func configureText(text: String?) {
    label.text = text
  }
  
  private func bind() {
    self.rx.tapped
      .subscribe(with: self, onNext: { owner, _ in
        let newValue = !owner.isSelected.value
        owner.isSelected.accept(newValue)
      })
      .disposed(by: disposeBag)
    
    isSelected
      .subscribe(with: self, onNext: { owner, isSelected in
        owner.setSelected(isSelected)
      })
      .disposed(by: disposeBag)
  }
  
  private func setSelected(_ isSelected: Bool) {
    configureStyle(style: isSelected ? selectedStyle : style)
    configureText(text: isSelected ? selectedText : text)
  }
  
  private func configureAttributes() {
    layer.cornerRadius = cornerRadius
    clipsToBounds = true
    
    label.font = font
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
    case .date:
      backgroundColor = ResourceKitAsset.Colors.gray900.color.withAlphaComponent(0.5)
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
    case .none:
      break
    }
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
  
  public var isTapped: Observable<Bool> {
    return base.isSelected.asObservable()
  }
}
