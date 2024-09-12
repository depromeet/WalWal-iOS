//
//  FCMEdgeView.swift
//  FCMPresenterImp
//
//  Created by Jiyeon on 9/11/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem
import ResourceKit

import FlexLayout
import PinLayout
import Then

final class FCMEdgeView: UIView {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  
  // MARK: - UI
  
  private let rootContainerView = UIView()
  private let titleLabel = CustomLabel(
    text: "앗..",
    font: Fonts.LotteriaChab.Buster_Cute
  ).then {
    $0.textColor = Colors.black.color
  }
  private let subTitelLabel = CustomLabel(
    text: "아직 알림이 없어요!",
    font: Fonts.KR.H5.B
  ).then {
    $0.textColor = Colors.black.color
  }
  private let guideLabel = CustomLabel(
    text: "조금만 기다리면 알림이 올 거예요",
    font: Fonts.KR.H7.M
  ).then {
    $0.textAlignment = .center
    $0.textColor = Colors.black.color
  }
  
  // MARK: - Initialize
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configAttributes()
    configLayout()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    rootContainerView.pin
      .all()
    rootContainerView.flex
      .layout(mode: .adjustHeight)
  }
  
  private func configAttributes() {
    addSubview(rootContainerView)
  }
  
  private func configLayout() {
    rootContainerView.flex
      .justifyContent(.center)
      .alignItems(.center)
      .define {
        $0.addItem(titleLabel)
        $0.addItem(subTitelLabel)
          .marginTop(6)
        $0.addItem(guideLabel)
          .marginTop(2)
      }
  }
  
  
}
