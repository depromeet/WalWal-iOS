//
//  TabBarItemView.swift
//  DesignSystem
//
//  Created by 조용인 on 7/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

class TabBarItemView: UIView {
  
  // MARK: - UI
  
  private let containerView = UIView()
  
  private let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let titleLabel = UILabel().then {
    $0.font = ResourceKitFontFamily.KR.Caption
    $0.textAlignment = .center
  }
  
  // MARK: - Properties
  
  let item: TabBarItem
  
  private let isSelectedRelay = BehaviorRelay<Bool>(value: false)
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init(with item: TabBarItem) {
    self.item = item
    super.init(frame: .zero)
    configureViews()
    configureLayout()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycles
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin.all()
    containerView.flex.layout()
  }
  
  // MARK: - Methods
  
  func selected(_ isSelected: Bool) {
    isSelectedRelay.accept(isSelected)
  }
}

// MARK: - Private Methods

extension TabBarItemView {
  private func configureViews() {
    addSubview(containerView)
    containerView.addSubview(iconImageView)
    containerView.addSubview(titleLabel)
    
    titleLabel.text = item.title
  }
  
  private func configureLayout() {
    containerView.flex.define { flex in
      flex.addItem()
        .justifyContent(.center)
        .alignItems(.center)
        .grow(1)
        .define { flex in
          flex.addItem(iconImageView)
            .size(24)
            .marginBottom(4)
          flex.addItem(titleLabel)
            .width(100%)
        }
    }
  }
  
  private func bind() {
    isSelectedRelay
      .distinctUntilChanged()
      .subscribe(with: self, onNext: { owner, isSelected in
        owner.updateAppearance(isSelected: isSelected)
      })
      .disposed(by: disposeBag)
  }
  
  private func updateAppearance(isSelected: Bool) {
    iconImageView.image = isSelected 
    ? item.selectedIcon
    : item.icon
    titleLabel.textColor = isSelected
    ? ResourceKitAsset.Colors.black.color
    : ResourceKitAsset.Colors.gray200.color
  }
}

extension Reactive where Base: TabBarItemView {
  var tapped: ControlEvent<Void> {
    ControlEvent(events: base.rx.tapGesture().when(.recognized).map { _ in })
  }
  
  var isSelected: Binder<Bool> {
    return Binder(base) { view, isSelected in
      view.selected(isSelected)
    }
  }
}
