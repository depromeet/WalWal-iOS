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
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
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
  
  fileprivate let leftIcon = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  // MARK: - Properties
  
  private var text: String?
  private var selectedText: String?
  private let opacity: CGFloat
  private let image: UIImage?
  private let style: ChipStyle
  private let selectedStyle: ChipStyle
  private let font: UIFont
  
  private let disposeBag = DisposeBag()
  fileprivate let isSelected = BehaviorRelay<Bool>(value: false)
  
  // MARK: - Initializers
  
  /// WalWalChip을 초기화합니다.
  /// - Parameters:
  ///   - text: 초기 Chip의 타이틀 입니다
  ///   - selectedText: 선택되었을 때의 Chip의 타이틀 입니다.
  ///   - opacity: Chip의 투명도 입니다. (default: 1)
  ///   - image: Chip의 왼쪽에 들어갈 아이콘 입니다.
  ///   - style: Chip의 스타일 입니다.
  ///   - selectedStyle: 선택되었을 때의 Chip의 스타일 입니다. (default: .none)
  ///   - fond: Chip의 폰트 입니다. (default: Fonts.KR.B2)
  public init(
    text: String? = nil,
    selectedText: String? = nil,
    opacity: CGFloat = 1,
    image: UIImage? = nil,
    style: ChipStyle,
    selectedStyle: ChipStyle = .none,
    font: UIFont = ResourceKitFontFamily.KR.B2
  ) {
    self.text = text
    self.selectedText = selectedText == nil ? text : selectedText
    self.opacity = opacity
    self.image = image
    self.style = style
    self.selectedStyle = selectedStyle == .none ? style : selectedStyle
    self.font = font
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
    if self.text == nil {
      self.text = text
      self.selectedText = text
    }
    label.text = text
    label.sizeToFit()
    layoutSubviews()
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
    layer.cornerRadius = bounds.height / 2
    clipsToBounds = true
    
    label.font = font
    leftIcon.image = image
  }
  
  private func configureLayout() {
    addSubview(containerView)
    
    containerView.flex
      .direction(.row)
      .alignItems(.center)
      .justifyContent(.center)
      .padding(8, 15)
      .define { flex in
        if image != nil {
          flex.addItem(leftIcon)
            .marginRight(2)
        }
        flex.addItem(label)
          .shrink(1)
      }
  }
  
  fileprivate func configureStyle(style: ChipStyle) {
    switch style {
    case .filled:
      containerView.backgroundColor = Colors.gray900.color.withAlphaComponent(opacity)
      label.textColor = Colors.white.color
      layer.borderWidth = 0
    case .date:
      backgroundColor = ResourceKitAsset.Colors.gray900.color.withAlphaComponent(0.5)
      label.textColor = ResourceKitAsset.Colors.white.color
      layer.borderWidth = 0
    }
    case .outlined:
      containerView.backgroundColor = Colors.white.color.withAlphaComponent(opacity)
      label.textColor = Colors.gray900.color
      layer.borderWidth = 1
      layer.borderColor = Colors.gray150.color.cgColor
    case .tonal:
      containerView.backgroundColor = Colors.gray150.color.withAlphaComponent(opacity)
      label.textColor = Colors.gray600.color
      layer.borderWidth = 0
    case .none:
      break
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
