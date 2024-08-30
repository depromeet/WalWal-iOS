//
//  WalWalLoadingIndicator.swift
//  DesignSystem
//
//  Created by 이지희 on 8/21/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit

import Lottie
import Then
import FlexLayout
import PinLayout
import RxSwift
import RxCocoa

final class WalWalRefreshControl: UIRefreshControl {
  let indicatorView: LottieAnimationView = {
    let animationView = LottieAnimationView(animation: AnimationAsset.refersh.animation)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    return animationView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupAnimationViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupAnimationViews() {
    self.tintColor = .clear
    self.addSubview(indicatorView)
    self.clipsToBounds = true
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    indicatorView.flex.height(self.height)
    indicatorView.pin.center()
    
    indicatorView.play()
  }
}
