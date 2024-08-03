//
//  OnboardingProfileView.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/24/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import AuthPresenter
import ResourceKit
import DesignSystem
import Utility

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class OnboardingProfileViewControllerImp<R: OnboardingProfileReactor>:
  UIViewController,
  OnboardingProfileViewController {
  typealias Color = ResourceKitAsset.Colors
  typealias Font = ResourceKitFontFamily.KR
  
  private let profileSize: CGFloat = 170.adjusted
  private let marginProfileItem: CGFloat = 17.adjusted
  
  public var disposeBag = DisposeBag()
  private var onboardingReactor: R
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let navigationBar = WalWalNavigationBar(leftItems: [.back], title: nil, rightItems: [])
  private let contentContainer = UIView()
  private let progressView = ProgressView(index: 2)
  private let titleView = UIView()
  private let titleLabel = UILabel().then {
    $0.text = "왈왈에서 사용할\n프로필을 만들어주세요"
    $0.numberOfLines = 2
    $0.font = Font.H3
    $0.textColor = Color.black.color
  }
  private let subTitleLabel = UILabel().then {
    $0.text = "반려동물 사진을 직접 추가해보세요!"
    $0.font = Font.B1
    $0.textColor = Color.gray600.color
  }
  private let profileSelectView = ProfileSelectView()
  private let nicknameTextField = WalWalInputBox(
    defaultState: .active,
    placeholder: "닉네임을 입력해주세요",
    rightIcon: .close
  )
  private let nextButton = CompleteButton(isEnable: true)
  
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
    navigationController?.navigationBar.isHidden = true
    view.backgroundColor = .white
    view.addSubview(rootContainer)
    [navigationBar, progressView, titleView, contentContainer, nextButton].forEach {
      rootContainer.addSubview($0)
    }
    [titleLabel, subTitleLabel].forEach {
      titleView.addSubview($0)
    }
  }
  
  public func setLayout() {
    rootContainer.flex
      .justifyContent(.center)
    
    navigationBar.flex
      .width(100%)
    
    progressView.flex
      .marginTop(24.adjusted)
      .marginHorizontal(20)
    
    titleView.flex
      .marginHorizontal(20.adjustedWidth)
      .marginTop(40.adjusted)
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
          .marginTop(70.adjustedHeight)
          .width(100%)
        $0.addItem(nicknameTextField)
          .justifyContent(.center)
          .marginTop(32.adjustedHeight)
          .marginHorizontal(20.adjustedWidth)
      }
    nextButton.flex
      .marginHorizontal(20.adjustedWidth)
  }
  
  private func updateKeyboardLayout() {
    let keyboardTop = view.pin.keyboardArea.height - view.pin.safeArea.bottom
    nextButton.pin
      .bottom(keyboardTop + 20)
    view.layoutIfNeeded()
  }
  
  private func hideKeyboardLayout() {
    nextButton.pin
      .bottom(30)
      .height(56)
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
    nextButton.rx.tap
      .withLatestFrom(nicknameTextField.rx.text.orEmpty) {
        if $1.count > 14 {
          return self.cutNickname(text: $1)
        }
        return $1
      }
      .map { Reactor.Action.checkNickname($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.pulse(\.$invalidMessage)
      .asDriver(onErrorJustReturn: "")
      .filter {
        !$0.isEmpty
      }
      .drive(with: self) { owner, message in
        owner.nicknameTextField.rx.errorMessage.onNext(message)
      }
      .disposed(by: disposeBag)
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
    
    navigationBar.leftItems?.first?.rx.tapped
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    profileSelectView.showPHPicker
      .bind(with: self) { owner, _ in
        PHPickerManager.shared.presentPicker(vc: owner)
      }
      .disposed(by: disposeBag)
    
    nicknameTextField.rx.text.orEmpty
      .subscribe(with: self, onNext: { owner, text in
        owner.nextButton.isEnabled = text.count > 1
        if text.count > 14 {
          let cutText = owner.cutNickname(text: text)
          owner.nicknameTextField.changeText(text: cutText)
        }
      })
      .disposed(by: disposeBag)
    
  }
  
  /// 닉네임 14글자로 자르는 메서드
  private func cutNickname(text: String) -> String {
    let maxIndex = text.index(text.startIndex, offsetBy: 13)
    let startIndex = text.startIndex
    let cutting = String(text[startIndex...maxIndex])
    return cutting
  }
}

