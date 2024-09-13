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
  private var keyboardHeight: CGFloat = 0
  
  public var disposeBag = DisposeBag()
  private var onboardingReactor: R
  private let enableButtonStyle: WalWalButtonType = .custom(
    backgroundColor: Color.gray300.color,
    titleColor: Color.white.color,
    font: Font.H6.B,
    isEnable: true
  )
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let scrollView = UIScrollView()
  private let contentContainer = UIView()
  private let navigationBar = WalWalNavigationBar(leftItems: [.darkBack], leftItemSize: 40, title: nil, rightItems: [])
  private let profileContainer = UIView()
  private let progressView = ProgressView(index: 2)
  private let titleView = UIView()
  private let titleLabel = CustomLabel(
    text: "왈왈에서 사용할\n프로필을 만들어주세요",
    font: Font.H3
  ).then {
    $0.numberOfLines = 2
    $0.textColor = Color.black.color
  }
  private let subTitleLabel = CustomLabel(
    text: "반려동물 사진을 직접 추가해보세요!",
    font: Font.B1
  ).then {
    $0.textColor = Color.gray600.color
  }
  private lazy var profileSelectView = WalWalProfile(
    type: PetType(rawValue: petType) ?? .dog
  )
  private let nicknameTextField = WalWalInputBox(
    defaultState: .active,
    placeholder: "닉네임을 입력해주세요",
    rightIcon: .close
  )
  private lazy var nextButton = WalWalButton(
    type: enableButtonStyle,
    title: "다음"
  )
  
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
    
    rootContainer.flex
      .justifyContent(.start)
    
    navigationBar.flex
      .width(100%)
    
    progressView.flex
      .marginTop(24.adjustedHeight)
      .marginHorizontal(20)
    contentContainer.flex
      .justifyContent(.start)
    
    titleView.flex
      .marginHorizontal(20.adjustedWidth)
      .marginTop(40.adjustedHeight)
      .define {
        $0.addItem(titleLabel)
        $0.addItem(subTitleLabel)
          .marginTop(4)
      }
      
    profileContainer.flex
      .justifyContent(.start)
      .marginTop(70.adjustedHeight)
      .grow(1)
      .define {
        $0.addItem(profileSelectView)
          .alignItems(.center)
          .width(100%)
        $0.addItem(nicknameTextField)
          .marginTop(31.adjustedHeight)
          .marginHorizontal(20.adjustedWidth)
        
      }
    nextButton.flex
      .marginHorizontal(20.adjustedWidth)
  }
  
  private func updateKeyboardLayout() {
    
    let keyboardTop = view.pin.keyboardArea.height - view.pin.safeArea.bottom
    let scrollOffset = titleView.frame.height + 40.adjustedHeight + 71.adjustedHeight/2
    keyboardHeight = keyboardTop
    
    nextButton.pin
      .bottom(keyboardTop + 20.adjustedHeight)
    
    scrollView.contentOffset.y += scrollOffset
    profileContainer.pin
      .above(of: nextButton)
    
    view.layoutIfNeeded()
  }
  
  private func hideKeyboardLayout() {
    keyboardHeight = 0
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
        Reactor.Action.register(
          nickname: $1.0,
          profile: $1.1,
          petType: self.petType
        )
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    profileSelectView.showPHPicker
      .observe(on: MainScheduler.instance)
      .map { Reactor.Action.checkPhotoPermission }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    navigationBar.leftItems?.first?.rx.tapped
      .map { Reactor.Action.tapBackButton }
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
      .map {
        $0.buttonEnable ? .active : self.enableButtonStyle
      }
      .bind(to: nextButton.rx.buttonType)
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$isGrantedPhoto)
      .asDriver(onErrorJustReturn: false)
      .skip(1)
      .drive(with: self) { owner, isAllowed in
        if isAllowed {
          PHPickerManager.shared.presentPicker(vc: owner, pickerType: .profile)
        } else {
          WalWalAlert.shared.showOkAlert(
            title: "앨범에 대한 접근 권한이 없습니다",
            bodyMessage: "설정 > 왈왈 탭에서 접근을 활성화 할 수 있습니다.",
            okTitle: "확인"
          )
        }
      }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$errorMessage)
      .asDriver(onErrorJustReturn: "")
      .filter { !$0.isEmpty }
      .drive(with: self) { owner, message in
        WalWalToast.shared.show(type: .error, message: message, keyboardHeight: owner.keyboardHeight)
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
        owner.view.endEditing(true)
      }
      .disposed(by: disposeBag)
    
    PHPickerManager.shared.selectedPhotoForProfile
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
    
    WalWalAlert.shared.resultRelay
      .map { _ in Void() }
      .observe(on: MainScheduler.instance)
      .bind(to: WalWalAlert.shared.closeAlert)
      .disposed(by: disposeBag)
  }
}
