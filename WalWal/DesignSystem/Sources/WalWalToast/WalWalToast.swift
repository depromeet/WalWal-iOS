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
  
  private let fadeInDuration: TimeInterval = 0.3
  private let maintenanceTime: TimeInterval = 1.5
  private let fadeOutDutaion: TimeInterval = 0.5
  private let bottomMargin: CGFloat = 13
  private var keyboardHeight: CGFloat = 0
  
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
  
  private func configureLayout() {
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
    updateToastPosition()
  }
  
  private func updateToastPosition() {
    guard let window = UIWindow.key else { return }
    let safeAreaBottomInset = window.topViewControllerSafeAreaInsets?.bottom ?? 34
    let bottomOffset = safeAreaBottomInset + keyboardHeight + bottomMargin
    
    container.pin
      .horizontally(16)
      .bottom(bottomOffset)
    container.flex
      .layout(mode: .adjustHeight)
    container.pin
      .bottom(bottomOffset-10)
  }
  
  /// 토스트 메세지 띄우는 메서드
  ///
  /// - Parameters:
  ///   - type: 토스트 메세지 타입(타입에 따라 아이콘이 달라짐)
  ///   - message: 토스트 메세지 내용, nil일 경우 ToastType에 지정된 기본 메세지 출력
  ///   - keyboardHeight: 키보드 올라와있을 경우 키보드 위로 띄우기 위한 높이 파라미터
  public func show(
    type: ToastType,
    message: String? = nil,
    keyboardHeight: CGFloat = 0
  ) {
    guard let window = UIWindow.key else { return }
    self.keyboardHeight = keyboardHeight
    self.messageLabel.text = message ?? type.message
    self.iconImage.image = type.icon
    window.addSubview(container)
    configureLayout()
    window.bringSubviewToFront(container)
    
    render()
  }
  
  private func render() {
    guard let window = UIWindow.key else { return }
    let safeAreaBottomInset = window.topViewControllerSafeAreaInsets?.bottom ?? 34
    let bottomOffset = safeAreaBottomInset + keyboardHeight + bottomMargin
    UIView.animate(
      withDuration: self.fadeInDuration,
      delay: 0,
      options: [.allowUserInteraction, .curveEaseOut],
      animations: { [weak self] in
        guard let self = self else {
          return
        }
        
        self.container.transform = CGAffineTransform(translationX: 0, y: -10)
        self.container.pin.bottom(bottomOffset)
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
            self.container.transform = .identity
          },
          completion: { _ in
            self.container.removeFromSuperview()
          }
        )
      }
    )
  }
  
}

extension UIWindow {
  
  private func topViewController() -> UIViewController? {
    return self.topViewController(rootViewController: self.rootViewController)
  }
  
  private func topViewController(rootViewController: UIViewController?) -> UIViewController? {
    if let presentedViewController = rootViewController?.presentedViewController {
      return topViewController(rootViewController: presentedViewController)
    }
    
    if let navigationController = rootViewController as? UINavigationController {
      return topViewController(rootViewController: navigationController.visibleViewController)
    }
    
    if let tabBarController = rootViewController as? UITabBarController {
      return topViewController(rootViewController: tabBarController.selectedViewController)
    }
    return rootViewController
  }
  
  /// 최상위 뷰의 safeAreaInsets를 반환
  var topViewControllerSafeAreaInsets: UIEdgeInsets? {
    guard let topViewController = self.topViewController() else { return nil }
    return topViewController.view.safeAreaInsets
  }
}


