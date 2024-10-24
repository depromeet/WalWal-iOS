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

public final class WalWalRefreshControl: UIRefreshControl {
  
  public var indicatorIsHidden = PublishRelay<Bool>()
  private let disposeBag = DisposeBag()
  
  let indicatorView: LottieAnimationView = {
    let animationView = LottieAnimationView(animation: AnimationAsset.refersh.animation)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    return animationView
  }()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    bind()
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
  
  private func bind() {
    indicatorIsHidden
      .distinctUntilChanged()
      .bind(to: indicatorView.rx.isHidden)
      .disposed(by: disposeBag)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    indicatorView.flex.height(self.height)
    indicatorView.pin.center()
    
    indicatorView.play()
  }
}
