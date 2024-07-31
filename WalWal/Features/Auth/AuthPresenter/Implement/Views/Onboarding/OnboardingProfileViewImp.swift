//
//  OnboardingProfileView.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/24/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import AuthPresenter

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class OnboardingProfileViewControllerImp<R: OnboardingProfileReactor>:
  UIViewController,
  OnboardingProfileViewController {
  
  
  public var disposeBag = DisposeBag()
  private var onboardingReactor: R
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let contentContainer = UIView()
  private let progressView = ProgressView(index: 2)
  private let titleView = UIView()
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
  private var profileSelectView = ProfileSelectView(
    viewWidth: UIScreen.main.bounds.width,
    marginItems: 17
  )
  private let nicknameTextField = NicknameTextField()
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
    let _ = view.pin.keyboardArea.height
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
    hideKeyboardLayout()
  }
  
  public func setAttribute() {
    view.backgroundColor = .white
    view.addSubview(rootContainer)
    [progressView, titleView, contentContainer, nextButton].forEach {
      rootContainer.addSubview($0)
    }
    [titleLabel, subTitleLabel].forEach {
      titleView.addSubview($0)
    }
  }
  
  public func setLayout() {
    rootContainer.flex
      .justifyContent(.center)
    progressView.flex
      .marginTop(32)
      .marginHorizontal(20)
    titleView.flex
      .marginHorizontal(20)
      .marginTop(32/812*UIScreen.main.bounds.height)
      .define {
        $0.addItem(titleLabel)
        $0.addItem(subTitleLabel)
          .marginTop(4)
      }
    contentContainer.flex
      .justifyContent(.start)
      .grow(1)
      .define {
        $0.addItem(profileSelectView)
          .alignItems(.center)
          .marginTop(70/812*UIScreen.main.bounds.height)
          .width(100%)
        $0.addItem(nicknameTextField)
          .justifyContent(.center)
          .marginTop(32)
          .marginHorizontal(20)
      }
    nextButton.flex
      .marginHorizontal(20)
  }
  
  private func updateKeyboardLayout() {
    let keyboardTop = view.pin.keyboardArea.height - view.pin.safeArea.bottom
    nextButton.pin.bottom(keyboardTop + 20)
    view.layoutIfNeeded()
  }
  
  private func hideKeyboardLayout() {
    nextButton.pin.bottom(30).height(56)
  }
}

// MARK: - Binding

extension OnboardingProfileViewControllerImp: View {
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
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .bind(with: self) { owner, _ in
        owner.updateKeyboardLayout()
      }
      .disposed(by: disposeBag)
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, noti in
        owner.hideKeyboardLayout()
      }
      .disposed(by: disposeBag)
    nicknameTextField.textField.rx.controlEvent(.editingDidEndOnExit)
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.nicknameTextField.textField.resignFirstResponder()
      }
      .disposed(by: disposeBag)
  }
}

