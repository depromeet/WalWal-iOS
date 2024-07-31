//
//  WalWalTabBarView.swift
//  DesignSystem
//
//  Created by 조용인 on 7/30/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import RxSwift
import RxCocoa
import PinLayout
import FlexLayout
import Then

final class WalWalTabBarView: UIView {
  
  // MARK: - UI
  
  private let containerView = UIView()
  
  private let missionItemView = TabBarItemView(with: .mission)
  
  private let feedItemView = TabBarItemView(with: .feed)
  
  private let notificationItemView = TabBarItemView(with: .notification)
  
  private let myPageItemView = TabBarItemView(with: .mypage)
  
  private var tabBarItems: [TabBarItemView] {
    [missionItemView, feedItemView, notificationItemView, myPageItemView]
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
      .layout(mode: .adjustHeight)
  }
}

// MARK: - Private Methods

extension WalWalTabBarView {
  private func configureViews() {
    addSubview(containerView)
    
    containerView.flex.define { flex in
      flex.addItem()
        .direction(.row)
        .justifyContent(.spaceEvenly)
        .alignItems(.center)
        .height(68)
        .define { flex in
          tabBarItems.forEach { itemView in
            flex.addItem(itemView)
              .grow(1)
              .shrink(1)
              .basis(0)
          }
        }
    }
  }
  
  private func bind() {
    Observable.merge(
      tabBarItems.enumerated().map { index, item in
        item.rx.tapped.map { index }
      }
    )
    .bind(to: selectedIndex)
    .disposed(by: disposeBag)
    
    selectedIndex
      .subscribe(with: self, onNext: { owner, index in
        owner.tabBarItems.enumerated().forEach { itemIndex, item in
          item.rx.isSelected.onNext(itemIndex == index)
        }
      })
      .disposed(by: disposeBag)
  }
}
