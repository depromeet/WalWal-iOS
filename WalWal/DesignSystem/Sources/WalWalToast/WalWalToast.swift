//
//  WalWalToast.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import FlexLayout
import PinLayout
import Then

public final class WalWalToast {
  
  public static let shared = WalWalToast()
  private init() { }
  
  private typealias FontKR = ResourceKitFontFamily.KR
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Images = ResourceKitAsset.Images
  
  private let fadeInDuration: TimeInterval = 0.25
  private let maintenanceTime: TimeInterval = 2
  private let fadeOutDutaion: TimeInterval = 0.5
  private let tabbarHeight: CGFloat = 68
  private let bottomMargin: CGFloat = 13
  
  // MARK: - UI
  
  private var window: UIWindow?
  private let container = UIView().then {
    $0.backgroundColor = Colors.black85.color
    $0.layer.cornerRadius = 14
  }
  
  private let iconImage = UIImageView().then {
    $0.backgroundColor = .clear
  }
  
  private let messageLabel = UILabel().then {
    $0.font = FontKR.H7.B
    $0.textColor = Colors.white.color
    $0.numberOfLines = 1
  }
  
  // MARK: - Layout
  
  private func configureLayout(bottom: CGFloat) {
    guard let window = UIWindow.key else { return }
    let safeAreaBottomInset = window.safeAreaInsets.bottom
    
    container.flex
      .direction(.row)
      .height(56)
      .alignItems(.center)
      .define {
        $0.addItem(iconImage)
          .size(30)
          .marginLeft(12)
        $0.addItem(messageLabel)
          .marginLeft(6)
          .grow(1)
      }
    
    container.pin
      .horizontally(16)
      .bottom(safeAreaBottomInset+bottom)
    container.flex
      .layout(mode: .adjustHeight)
    container.pin
      .bottom(safeAreaBottomInset+bottom)
  }
  
  /// 토스트 메세지 띄우는 메서드
  ///
  /// - Parameters:
  ///   - type: 토스트 메세지 타입(타입에 따라 아이콘이 달라짐)
  ///   - message: 토스트 메세지 내용, nil일 경우 ToastType에 지정된 기본 메세지 출력
  ///   - tabBarShown: default value: `false`, 토스트 메세지를 띄울 뷰에 탭바 존재 여부(하단 여백이 다름)
  public func show(
    type: ToastType,
    message: String? = nil,
    isTabBarExist: Bool = true
  ) {
    guard let window = UIWindow.key else { return }
    
    self.messageLabel.text = message ?? type.message
    self.iconImage.image = type.icon
    
    window.addSubview(container)
    configureLayout(bottom: isTabBarExist ? bottomMargin+tabbarHeight : bottomMargin)
    window.bringSubviewToFront(container)
    
    render()
  }
  
  private func render() {
    UIView.animate(
      withDuration: self.fadeInDuration,
      delay: 0,
      options: [.allowUserInteraction, .transitionCrossDissolve],
      animations: { [weak self] in
        guard let self = self else {
          return
        }
        container.alpha = 1.0
      },
      completion: { [weak self] _ in
        guard let self = self else {
          return
        }
        UIView.animate(
          withDuration: self.fadeOutDutaion,
          delay: self.maintenanceTime,
          options: [.allowUserInteraction, .transitionCrossDissolve],
          animations: {
            self.container.alpha = 0.0
          },
          completion: { _ in
            self.container.removeFromSuperview()
          }
        )
      }
    )
  }
  
}
