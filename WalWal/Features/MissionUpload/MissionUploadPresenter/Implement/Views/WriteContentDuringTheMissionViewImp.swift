//
//  WriteContentDuringTheMissionViewImp.swift
//  MissionUploadPresenter
//
//  Created by 조용인 on 8/21/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import MissionUploadPresenter
import ResourceKit
import DesignSystem
import Utility
import Lottie

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class WriteContentDuringTheMissionViewControllerImp<R: WriteContentDuringTheMissionReactor>:
  UIViewController,
  WriteContentDuringTheMissionViewController {
  
  private typealias Images = ResourceKitAsset.Images
  private typealias Assets = ResourceKitAsset.Assets
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  private let rootFlexContainer = UIView()
  
  // 네비게이션 컨테이너
  private let navigationContainer = UIView()
  private let backButton = WalWalTouchArea(
    image: Images.backL.image,
    size: 40
  )
  
  // 이미지 프리뷰 컨테이너
  private let imagePreviewContainer = UIView()
  private lazy var previewImageView = UIImageView().then {
    $0.image = capturedImage
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 20
  }
  
  // 콘텐츠 입력 컨테이너
  private let contentInputContainer = UIView()
  private lazy var contentTextView = StyledTextInputView(
    placeholderText: "함께한 추억을 기록해주세요",
    maxCharacterCount: 80
  ).then {
    $0.layer.cornerRadius = 20
  }
  
  private let characterCountContainer = UIView()
  private lazy var characterCountLabel = UILabel().then {
    $0.font = Fonts.EN.Caption
    $0.textColor = Colors.white.color.withAlphaComponent(0.2)
    $0.text = "0/80"
  }
  
  // 업로드 버튼 컨테이너
  private let uploadContainer = UIView()
  private let uploadButtonLabel = UILabel().then {
    $0.text = "피드에 자랑하기"
    $0.font = Fonts.KR.H3
    $0.textColor = Colors.white.color
  }
  
  private let uploadButton = WalWalTouchArea(
    image: Images.arrowL.image,
    size: 40
  )
  
  private let missionUploadCompletedLottieView: LottieAnimationView = {
    let animationView = LottieAnimationView(animation: AnimationAsset.missionComplete.animation)
    animationView.loopMode = .loop
    return animationView
  }()
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  public var writeContentDuringTheMissionReactor: R
  
  private let capturedImage: UIImage
  fileprivate var keyboardHeight: CGFloat = 0
  private var isFirstAppearance = true
  
  public init(
    reactor: R,
    capturedImage: UIImage
  ) {
    self.writeContentDuringTheMissionReactor = reactor
    self.capturedImage = capturedImage
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    configureAttribute()
    configureLayout()
    self.reactor = self.writeContentDuringTheMissionReactor
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootFlexContainer.pin
      .all(view.pin.safeArea)
    rootFlexContainer.flex
      .layout()
    uploadContainer.flex
      .layout()
    uploadContainer.pin
      .bottomCenter(view.pin.safeArea.bottom + 50)
      .width(100%)
      .height(50)
    
    if isFirstAppearance {
      contentTextView.textView.becomeFirstResponder()
      isFirstAppearance = false
    }
    updateLayout()
  }
  
  // MARK: - Methods
  
  public func configureAttribute() {
    view.backgroundColor = UIColor(hex: 0x1b1b1b)
  }
  
  public func configureLayout() {
    
    [rootFlexContainer, uploadContainer].forEach {
      view.addSubview($0)
    }
    
    let isKeyboardVisible = keyboardHeight > 0
    let previewImageHeight: CGFloat = isKeyboardVisible ? 160.adjusted : 240.adjusted
    let imagePreviewContainerMarginTop: CGFloat = isKeyboardVisible ? 15.adjusted : 50.adjusted
    let contentInputMarginTop: CGFloat = isKeyboardVisible ? 40.adjusted : 50.adjusted
    
    rootFlexContainer.flex
      .define { flex in
        flex.addItem(navigationContainer)
          .height(40)
          .marginTop(26)
          .marginHorizontal(10)
        flex.addItem(imagePreviewContainer)
          .alignSelf(.center)
          .marginTop(imagePreviewContainerMarginTop)
          .aspectRatio(1.0)
          .width(previewImageHeight)
        flex.addItem(contentInputContainer)
          .alignSelf(.center)
          .marginTop(contentInputMarginTop)
          .marginHorizontal(30)
          .height(150.adjusted)
          .width(315.adjusted)
      }
    
    navigationContainer.flex.define { flex in
      flex.addItem(backButton).size(40)
    }
    
    imagePreviewContainer.flex.define { flex in
      flex.addItem(previewImageView).grow(1)
    }
    
    contentInputContainer.flex
      .define { flex in
        flex.addItem(contentTextView).grow(1)
        flex.addItem(characterCountLabel)
          .alignSelf(.end)
          .marginTop(6)
          .width(40)
      }
    
    uploadContainer.flex
      .direction(.row)
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
        flex.addItem(uploadButtonLabel)
        flex.addItem(uploadButton).size(40)
      }
  }
  
  private func updateLayout() {
    UIView.animate(withDuration: 0.3) {
      self.configureLayout()
      self.view.layoutIfNeeded()
    }
  }
  
  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    guard let touch = touches.first else { return }
    let location = touch.location(in: view)
    
    let inputBoxes = [contentTextView]
    let touchedOutside = inputBoxes.allSatisfy { !$0.frame.contains(location) }
    
    if touchedOutside {
      view.endEditing(true)
    }
  }
  
  fileprivate func showLottie() {
    guard let window = UIWindow.key else { return }
    
    let dimView = UIView(frame: window.bounds)
    dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    dimView.tag = 999
    
    missionUploadCompletedLottieView.center = window.center
    
    window.addSubview(dimView)
    window.addSubview(missionUploadCompletedLottieView)
    
    missionUploadCompletedLottieView.play()
  }
  
  fileprivate func hideLottie() {
    guard let window = UIWindow.key else { return }
    missionUploadCompletedLottieView.stop()
    window.viewWithTag(999)?.removeFromSuperview()
    missionUploadCompletedLottieView.removeFromSuperview()
  }
}

extension WriteContentDuringTheMissionViewControllerImp: View {
  
  // MARK: - Binding
  
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    backButton.rx.tapped
      .map { Reactor.Action.backButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    uploadContainer.rx.tapped
      .withLatestFrom(contentTextView.rx.text)
      .withUnretained(self)
      .map { owner, content in
        Reactor.Action.uploadButtonTapped(
          capturedImage: owner.capturedImage,
          content: content
        )
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    WalWalAlert.shared.resultRelay
      .map {
        $0 == .ok
        ? Reactor.Action.deleteThisContent
        : Reactor.Action.keepThisContent
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.isAlertWillPresent }
      .distinctUntilChanged()
      .subscribe(onNext: { isAlertWillPresent in
        if isAlertWillPresent {
          WalWalAlert.shared.show(
            title: "기록을 삭제하시겠어요?",
            bodyMessage: "지금 돌아가면 입력하신 내용이 모두\n삭제됩니다.",
            cancelTitle: "계속 작성하기",
            okTitle: "삭제하기"
          )
        } else {
          WalWalAlert.shared.closeAlert.accept(())
        }
      })
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$uploadErrorMessage)
      .asDriver(onErrorJustReturn: "")
      .filter { !$0.isEmpty }
      .drive(onNext: { errorMessage in
        WalWalToast.shared.show(
          type: .error,
          message: errorMessage
        )
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map{ $0.showLottie}
      .distinctUntilChanged()
      .subscribe(with: self, onNext: { owner, showLottie in
        showLottie ? owner.showLottie() : owner.hideLottie()
      })
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .bind(with: self) { owner, _ in
        owner.keyboardHeight = 1
        owner.updateLayout()
      }
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, _ in
        owner.keyboardHeight = 0
        owner.updateLayout()
      }
      .disposed(by: disposeBag)
    
    contentTextView.textRelay
      .map { "\($0.count)/80" }
      .bind(to: characterCountLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
