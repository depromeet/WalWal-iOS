//
//  ProgressView.swift
//  OnboardingPresenter
//
//  Created by Jiyeon on 7/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import FlexLayout
import PinLayout

/// 온보딩 화면 상단에서 보여주기 위한 progress view
/// - parameters:
///   -  index: 현재 진행도(페이지)
final class ProgressView: UIView {
  private typealias Color = ResourceKitAsset.Colors
  private typealias Font = ResourceKitFontFamily.KR
  
  // MARK: - UI
  
  private let containerView = UIView()
  private let firstBar = UIView().then {
    $0.backgroundColor = Color.gray200.color
    $0.layer.cornerRadius = 2
  }
  private let secondBar = UIView().then {
    $0.backgroundColor = Color.gray200.color
    $0.layer.cornerRadius = 2
  }
  private lazy var barList = [firstBar, secondBar]
  
  // MARK: - Initialize
  
  init(index: Int) {
    super.init(frame: .zero)
    for i in 0..<index {
      barList[i].backgroundColor = Color.walwalOrange.color
    }
    addSubview(containerView)
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    containerView.pin
      .all()
    containerView.flex
      .layout()
  }
  private func configureLayout() {
    containerView.flex
      .direction(.row)
      .define {
        $0.addItem(firstBar)
          .height(4)
          .grow(1)
        $0.addItem(secondBar)
          .marginLeft(6)
          .height(4)
          .grow(1)
      }
  }
}
