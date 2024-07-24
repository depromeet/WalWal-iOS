//
//  OnboardingProfileView.swift
//  OnboardingPresenterImp
//
//  Created by Jiyeon on 7/24/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import OnboardingPresenter

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class OnboardingProfileViewController<R: OnboardingReactor>:
  UIViewController,
  OnboardingViewController {
  
  public var disposeBag = DisposeBag()
  private var onboardingReactor: R
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let contentContainer = UIView()
  private let progressView = ProgressView(index: 2)
  private let titleLabel = UILabel().then {
    $0.text = "왈왈에서 사용할\n프로필을 만들어주세요"
    $0.numberOfLines = 2
    $0.font = .boldSystemFont(ofSize: 24)
    $0.textColor = .black
  }
  private let subTitleLabel = UILabel().then {
    $0.text = "반려동물 사진을 직접 추가해보세요!"
    $0.font = .systemFont(ofSize: 14, weight: .medium)
    $0.textColor = .gray
  }
  private let nextButton = CompleteButton(isEnable: false)
  
  
  // MARK: - Initialize
  
  public init(reactor: R) {
    self.onboardingReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setAttribute()
    setLayout()
    self.reactor = onboardingReactor
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
  }
  
  public func setAttribute() {
    view.backgroundColor = .white
    view.addSubview(rootContainer)
    rootContainer.addSubview(progressView)
    rootContainer.addSubview(contentContainer)
    rootContainer.addSubview(nextButton)
  }
  
  public func setLayout() {
    rootContainer.flex.justifyContent(.center).marginHorizontal(20)
    progressView.flex.marginTop(32)
    contentContainer.flex.justifyContent(.start).grow(1).define {
      $0.addItem(titleLabel)
      $0.addItem(subTitleLabel)
    }
    nextButton.flex.marginBottom(30).height(56)
  }
}

// MARK: - Binding

extension OnboardingProfileViewController {
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    
  }
}
