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
  private let navigationBar = WalWalNavigationBar(leftItems: [.back], leftItemSize: 40, title: nil, rightItems: [])
  private let profileContainer = UIView()
  private let progressView = ProgressView(index: 2)
  private let titleView = UIView().then { $0.backgroundColor = .orange }
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
    setAttribute()
    setLayout()
    self.reactor = onboardingReactor
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    let _ = view.pin.keyboardArea.height
    rootContainer.pin.all(view.pin.safeArea)
    scrollView.pin.horizontally().bottom().below(of: progressView)//above(of: progressView)
    contentContainer.pin.top().horizontally()
    contentContainer.flex.layout(mode: .adjustHeight)
    scrollView.contentSize = contentContainer.frame.size
    
    rootContainer.flex.layout()
    hideKeyboardLayout()
  }
  
  public func setAttribute() {
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
  
  public func setLayout() {
    
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
      .bottom(keyboardTop + 20)
    
    scrollView.contentOffset.y += scrollOffset
    
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
      contentContainer.flex.markDirty()
      contentContainer.flex.layout()
    }
    nextButton.pin
      .bottom(30)
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
    let nicknameObservable = nicknameTextField.rx.text.orEmpty
      .throttle(.milliseconds(350), scheduler: MainScheduler.instance)
    
    let inputValue =  Observable.combineLatest(nicknameObservable, profileSelectView.curProfileItems)
    
    inputValue
      .map {
        Reactor.Action.checkCondition(nickname: $0, profile: $1)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    nextButton.rx.tap
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
      .drive(with: self) { owner, message in
        owner.nicknameTextField.rx.errorMessage.onNext(message)
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.buttonEnable }
      .bind(to: nextButton.rx.isEnabled)
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
      .asDriver()
      .drive(with: self) { owner, text in
        if text.count > owner.maxNicknameLength {
          owner.nicknameTextField.cutText(length: owner.maxNicknameLength, text: text)
        }
      }
      .disposed(by: disposeBag)
    
    
  }
}
