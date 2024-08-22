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
  private let navigationContainer = UIView()
  private let uploadContainer = UIView()
  
  private let backButton = WalWalTouchArea(
    image: Images.backL.image,
    size: 40
  )
  
  private lazy var previewImageView = UIImageView().then {
    $0.image = capturedImage
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 20
  }
  
  private lazy var contentTextView = StyledTextInputView(
    placeholderText: "오늘의 산책은 어땠나요?",
    maxCharacterCount: 80
  ).then {
    $0.layer.cornerRadius = 20
  }
  
  private let uploadButtonLabel = UILabel().then {
    $0.text = "피드에 자랑하기"
    $0.font = Fonts.KR.H3
    $0.textColor = Colors.white.color
  }
  
  private let uploadButton = WalWalTouchArea(
    image: Images.arrow.image,
    size: 40
  )
  
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
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if isFirstAppearance {
      contentTextView.textView.becomeFirstResponder()
      isFirstAppearance = false
    }
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    updateLayout()
  }
  
  // MARK: - Methods
  
  public func configureAttribute() {
    view.backgroundColor = Colors.black.color
  }
  
  public func configureLayout() {
    
    [rootFlexContainer, uploadContainer].forEach {
      view.addSubview($0)
    }
    
    [navigationContainer, previewImageView, contentTextView].forEach {
      rootFlexContainer.addSubview($0)
    }
    
    [uploadButtonLabel, uploadButton].forEach {
      uploadContainer.addSubview($0)
    }
    
    layoutView()
  }
  
  private func layoutView() {
    rootFlexContainer.pin
      .all(view.pin.safeArea)
    
    let isKeyboardVisible = keyboardHeight > 0
    let previewImageHeight: CGFloat = isKeyboardVisible ? 160 : 240
    
    rootFlexContainer.flex
      .direction(.column)
      .define { flex in
        flex.addItem(navigationContainer)
          .direction(.row)
          .justifyContent(.start)
          .marginTop(26)
          .marginHorizontal(10)
          .define { flex in
            flex.addItem(backButton)
              .size(40)
          }
        
        flex.addItem(previewImageView)
          .alignSelf(.center)
          .marginTop(20)
          .marginHorizontal(10)
          .aspectRatio(1)
          .width(previewImageHeight)
        
        flex.addItem(contentTextView)
          .marginTop(20)
          .marginHorizontal(15)
          .height(170)
      }
    
    uploadContainer.pin
      .bottomCenter(view.pin.safeArea.bottom + 30)
      .width(190)
      .height(50)
    
    uploadContainer.flex
      .direction(.row)
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
        flex.addItem(uploadButtonLabel)
        flex.addItem(uploadButton)
          .size(40)
      }
    
    rootFlexContainer.flex
      .layout()
    uploadContainer.flex
      .layout()
  }
  
  private func updateLayout() {
    UIView.animate(withDuration: 0.3) {
      self.layoutView()
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
    print("로띠를 띄워봐용~")
  }
  
  fileprivate func hideLottie() {
    print("로띠를 지워봐용~")
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
    
    reactor.state
      .map { $0.showCompletedLottie }
      .distinctUntilChanged()
      .subscribe(with: self, onNext: { owner, isShow in
        isShow ? owner.showLottie() : owner.hideLottie()
      })
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$uploadErrorMessage)
      .asDriver(onErrorJustReturn: "")
      .filter { !$0.isEmpty }
      .drive(onNext: { errorMessage in
        WalWalToast.shared.show(
          type: .error,
          message: errorMessage,
          isTabBarExist: false
        )
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map{ $0.isCompletedUpload}
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(with: self, onNext: { owner, _ in
        owner.showLottie()
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.showIndicator }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, show in
        ActivityIndicator.shared.showIndicator.accept(show)
      }
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
  }
}
