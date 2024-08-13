//
//  OnboardingProfileView.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/24/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import OnboardingPresenter
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
  private typealias Color = ResourceKitAsset.Colors
  private typealias Font = ResourceKitFontFamily.KR
  
  private let profileSize: CGFloat = 170.adjusted
  private let marginProfileItem: CGFloat = 17.adjusted
  private let maxNicknameLength: Int = 14
  private let petType: String
  
  public var disposeBag = DisposeBag()
  private var onboardingReactor: R
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let scrollView = UIScrollView()
  private let contentContainer = UIView()
  private let navigationBar = WalWalNavigationBar(leftItems: [.darkBack], leftItemSize: 40, title: nil, rightItems: [])
  private let profileContainer = UIView()
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
  private lazy var profileSelectView = WalWalProfile(type: PetType(rawValue: petType) ?? .dog)
  private let nicknameTextField = WalWalInputBox(
    defaultState: .active,
    placeholder: "닉네임을 입력해주세요",
    rightIcon: .close
  )
  private let nextButton = WalWalButton(type: .disabled, title: "다음")
  
  // MARK: - Initialize
  
  public init(reactor: R, petType: String = "") {
    self.onboardingReactor = reactor
    self.petType = petType
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureAttribute()
    configureLayout()
    self.reactor = onboardingReactor
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let _ = view.pin.keyboardArea.height
    rootContainer.pin
      .all(view.pin.safeArea)
    scrollView.pin
      .horizontally()
      .bottom()
      .below(of: progressView)
    contentContainer.pin
      .top()
      .horizontally()
    contentContainer.flex
      .layout(mode: .adjustHeight)
    scrollView.contentSize = contentContainer.frame.size
    
    rootContainer.flex
      .layout()
    hideKeyboardLayout()
  }
  
  public func configureAttribute() {
    navigationController?.navigationBar.isHidden = true
    view.backgroundColor = .white
    view.addSubview(rootContainer)
    
    rootContainer.addSubview(navigationBar)
    rootContainer.addSubview(progressView)
    rootContainer.addSubview(scrollView)
    rootContainer.addSubview(nextButton)
    scrollView.addSubview(contentContainer)
    
    [titleView, profileContainer].forEach {
      contentContainer.addSubview($0)
    }
    
    [titleLabel, subTitleLabel].forEach {
      titleView.addSubview($0)
    }
  }
  
  public func configureLayout() {
    
    navigationBar.flex
      .width(100%)
    
    progressView.flex
      .marginTop(24.adjusted)
      .marginHorizontal(20)
    contentContainer.flex
      .justifyContent(.center)
    
    titleView.flex
      .marginHorizontal(20.adjustedWidth)
      .marginTop(40.adjusted)
      .define {
        $0.addItem(titleLabel)
        $0.addItem(subTitleLabel)
          .marginTop(4)
      }
      
    profileContainer.flex
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
    let scrollOffset = titleView.frame.height + 40.adjustedHeight + 70.adjustedHeight/2
    
    nextButton.pin
      .bottom(keyboardTop + 20.adjustedHeight)
    
    scrollView.contentOffset.y += scrollOffset
    nicknameTextField.pin
      .bottom(20.adjustedHeight)
      .height(72)
    profileContainer.pin
      .above(of: nextButton)
      .bottom(10)
    profileSelectView.pin
      .above(of: nicknameTextField)
      .bottom(32.adjustedHeight)
      .below(of: progressView)
      .top(54.adjustedHeight)
    
    view.layoutIfNeeded()
  }
  
  private func hideKeyboardLayout() {
    
    if scrollView.contentOffset.y > 0 {
      scrollView.contentOffset.y = 0
      contentContainer.flex
        .markDirty()
      contentContainer.flex
        .layout()
    }
    nextButton.pin
      .bottom(30.adjustedHeight)
      .height(56)
    view.layoutIfNeeded()
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
    
    let inputValue =  Observable.combineLatest(nicknameTextField.rx.text.orEmpty, profileSelectView.curProfileItems)
    
    inputValue
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .map {
        Reactor.Action.checkCondition(nickname: $0, profile: $1)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    nextButton.rx.tapped
      .withLatestFrom(inputValue) {
        Reactor.Action.register(nickname: $1.0, profile: $1.1, petType: self.petType)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
  }
  
  public func bindState(reactor: R) {
    reactor.pulse(\.$invalidMessage)
      .asDriver(onErrorJustReturn: "")
      .filter {
        !$0.isEmpty
      }
      .drive(nicknameTextField.rx.errorMessage)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { return $0.buttonEnable ? .active : .disabled }
      .bind(to: nextButton.rx.buttonType)
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
        owner.view.endEditing(true)
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
    
    profileSelectView.showPHPicker
      .bind(with: self) { owner, _ in
        PHPickerManager.shared.presentPicker(vc: owner)
      }
      .disposed(by: disposeBag)
    
    PHPickerManager.shared.selectedPhoto
      .asDriver(onErrorJustReturn: nil)
      .compactMap { $0 }
      .drive(with: self) { owner, image in
        owner.profileSelectView.selectedImageData.accept(image)
      }
      .disposed(by: disposeBag)
    
    nicknameTextField.rx.text.orEmpty
      .asDriver()
      .drive(with: self) { owner, text in
        if text.count > owner.maxNicknameLength {
          owner.nicknameTextField.cutText(length: owner.maxNicknameLength, text: text)
        }
      }
      .disposed(by: disposeBag)
    
    
  }
}