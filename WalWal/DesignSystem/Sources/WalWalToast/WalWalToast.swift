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
  
  private func configureLayout(bottom: CGFloat = 13) {
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
    
    container.flex.layout(mode: .adjustHeight)
    
    container.pin
      .bottom(safeAreaBottomInset+bottom)
  }
  
  public func show(_ message: String, completion: (() -> Void)? = nil) {
    guard let window = UIWindow.key else { return }
    
    self.messageLabel.text = message
    self.iconImage.image = Images.check.image
    
    window.addSubview(container)
    configureLayout(bottom: 13)
    window.bringSubviewToFront(container)
    
    render(completion: completion)
  }
  
  private func render(completion: (() -> Void)?) {
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
            completion?()
          }
        )
      }
    )
  }
  
}
