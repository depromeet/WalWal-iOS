//
//  WalWalTabBarView.swift
//  DesignSystem
//
//  Created by 조용인 on 7/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout
import Then

final class WalWalTabBarView: UIView {
  
  // MARK: - UI
  
  private let containerView = UIView()
  
  private lazy var customItemViews: [TabBarItemView] = TabBarItem.allCases.map {
    TabBarItemView(with: $0)
  }
  
  // MARK: - Properties
  
  let selectedIndex = BehaviorRelay<Int>(value: 0)
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init() {
    super.init(frame: .zero)
    configureViews()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycles
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    containerView.pin
      .all()
    containerView.flex
      .layout()
  }
}

// MARK: - Private Methods

extension WalWalTabBarView {
  private func configureViews() {
    addSubview(containerView)
    
    containerView.flex
      .direction(.row)
      .justifyContent(.spaceAround)
      .define { flex in
        customItemViews.forEach {
          flex.addItem($0)
        }
    }
  }
  
  private func bind() {
    Observable.merge(
      customItemViews.enumerated()
        .map { index, item in
          item.rx.tapped.map { index }
        }
    )
    .bind(to: selectedIndex)
    .disposed(by: disposeBag)
    
    selectedIndex
      .subscribe(with: self, onNext: { owner, index in
        owner.customItemViews.enumerated().forEach { itemIndex, item in
          item.rx.isSelected.onNext(itemIndex == index)
        }
      })
      .disposed(by: disposeBag)
  }
}
