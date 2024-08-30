//
//  ActivityIndicator.swift
//  DesignSystem
//
//  Created by Jiyeon on 8/5/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import ResourceKit
import Lottie

import RxSwift
import RxCocoa
import Then
import FlexLayout
import PinLayout

/// 로딩 화면을 위한 ActivityIndicator 뷰
public final class ActivityIndicator {
  /// Indicator 애니메이션 시작 또는 중지 요청
  ///
  /// ```swift
  /// ActivityIndicator.shared.showIndicator.accpe(true)
  /// ```
  public var showIndicator = PublishRelay<Bool>()
  private var disposeBag = DisposeBag()
  private var isIndicatorShow: Bool = false
  
  public static let shared = ActivityIndicator()
  private init() {
    bind()
  }
  
  // MARK: - UI
  
  private let container = UIView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.white.color.withAlphaComponent(0)
  }
  private let indicatorBackGroundView = UIView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.white.color.withAlphaComponent(0.5)
    $0.layer.cornerRadius = 10
  }
  
  private var lottieAnimationView = LottieAnimationView(animation: AnimationAsset.refersh.animation)
  
  private var activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    indicator.hidesWhenStopped = true
    indicator.color = ResourceKitAsset.Colors.gray300.color
    return indicator
  }()
  
  private func bind() {
    showIndicator
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, show in
        if show {
          owner.startAnimating()
        } else {
          owner.stopAnimating()
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func startAnimating() {
    if isIndicatorShow {
      stopAnimating()
    }
    
    guard let window = UIWindow.key else { return }
    
    window.addSubview(container)
    window.bringSubviewToFront(container)
    container.addSubview(indicatorBackGroundView)
    indicatorBackGroundView.addSubview(lottieAnimationView)

    setLayout()
    isIndicatorShow = true
    
    lottieAnimationView.play()
    lottieAnimationView.loopMode = .loop
  }
  
  private func stopAnimating() {
    if isIndicatorShow {
      isIndicatorShow = false
      lottieAnimationView.stop()
      container.removeFromSuperview()
    }
  }
  
  private func setLayout() {
    container.pin
      .all()
    indicatorBackGroundView.pin
      .center()
      .size(100)
    lottieAnimationView.pin
      .center()
    container.flex
      .layout()
  }
}
