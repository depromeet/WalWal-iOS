//
//  ReportDetailViewImp.swift
//  FeedPresenterImp
//
//  Created by Jiyeon on 10/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//


import UIKit
import FeedPresenter
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxCocoa

public final class ReportDetailViewControllerImp<R: ReportDetailReactor>:
  UIViewController,
  ReportDetailViewController {
  
  private typealias Fonts = ResourceKitFontFamily
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Images = ResourceKitAsset.Images
  
  // MARK: - UI
  
  private let dimView = UIView().then {
    $0.backgroundColor = Colors.black30.color
  }
  
  private let rootContainer = UIView().then {
    $0.backgroundColor = Colors.white.color
    $0.isUserInteractionEnabled = true
  }
  
  private let contentContainer = UIView()
  
  private let navigation = WalWalNavigationBar(leftItems: [.darkBack], leftItemSize: 32, title: "신고", rightItems: [])
  
  private let discriptionLabel = CustomLabel(
    text: "구체적인 상황과 사유를 함께 적어주시면\n더 빠르고 정확하게 처리할 수 있어요! (선택)",
    font: Fonts.KR.H6.B
  ).then {
    $0.numberOfLines = 2
    $0.textColor = Colors.black.color
    $0.textAlignment = .center
  }
  
  private let textContainer = UIView()
  
  private let textView = ReportTextView(
    placeholder: "신고 내용을 더 빠르게 해결할 수 있도록 추가 정보를 제공해주세요",
    maxHeight: 239.adjustedHeight,
    minHeigh: 120.adjustedHeight,
    maxCount: 500
  )
  
  private let submitButton = WalWalButton(
    type: .dark,
    title: "왈왈팀에 전달하기"
  )
  
  // MARK: - Properties
  
  public var reportDetailReactor: R
  public var disposeBag = DisposeBag()
  private let sheetDownEvent = PublishRelay<Void>()
  private let endPanGesture = PublishRelay<CGPoint>()
  private let changePanGesture = PublishRelay<(CGPoint, CGPoint)>()
  private let dismissView = PublishRelay<Void>()
  private var isBottomSheet: Bool = true
  
  // MARK: - Initalize
  
  public init(reactor: R) {
    self.reportDetailReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.reactor = reportDetailReactor
    configureAttribute()
    configureLayout()
    self.view.backgroundColor = .clear
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    changeBottomSheet()
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let _ = view.pin.keyboardArea.height
    dimView.pin
      .all()
    dimView.flex
      .layout()
    
  }
  
  public func configureAttribute() {
    view.backgroundColor = .clear
    view.addSubview(dimView)
    rootContainer.layer.cornerRadius = 30
    rootContainer.layer.maskedCorners = CACornerMask(
      arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner
    )
    rootContainer.addSubview(contentContainer)
    [navigation, discriptionLabel, textContainer, submitButton].forEach {
      contentContainer.addSubview($0)
    }
    
  }
  
  public func configureLayout() {
    dimView.flex
      .define {
        $0.addItem(rootContainer)
          .position(.absolute)
          .bottom(0)
          .width(100%)
      }
    
    rootContainer.flex
      .height(563.adjustedHeight)
      .justifyContent(.start)
    
    contentContainer.flex
      .justifyContent(.spaceBetween)
      .grow(1)
    
    navigation.flex
      .height(22.adjustedHeight)
      .marginTop(24.adjustedHeight)
      .width(100%)
    
    discriptionLabel.flex
      .marginTop(30.adjustedHeight)
      .marginBottom(30.adjustedHeight)
      .marginHorizontal(20.adjustedWidth)
    
    submitButton.flex
      .marginHorizontal(20.adjustedWidth)
      .marginBottom(30.adjustedHeight)
      .height(50.adjustedHeight)
    
    textContainer.flex
      .backgroundColor(.red)
      .marginHorizontal(20.adjustedWidth)
      .marginBottom(20.adjustedWidth)
      .grow(1)
      .shrink(1)
      .define {
        $0.addItem(textView)
          .width(100%)
      }
    
  }
  
  private func changeFullPage() {
    isBottomSheet = false
    dimView.backgroundColor = Colors.white.color
    
    let keyboardTop = view.pin.keyboardArea.height
    
    contentContainer.flex
      .markDirty()
    rootContainer.pin
      .all()
    contentContainer.pin
      .all()
    
    contentContainer.flex
      .markDirty()
      .marginTop(view.pin.safeArea.top)
      .marginBottom(0)
      .layout()
    
    rootContainer.flex.markDirty()
    rootContainer.flex
      .marginBottom(0)
      .height(UIScreen.main.bounds.height)
      .layout()
    
    submitButton.pin
      .bottom(keyboardTop + 20.adjustedHeight)
    
    textContainer.pin
      .above(of: submitButton)
      .marginBottom(20.adjustedHeight)
      .below(of: discriptionLabel)
      .marginTop(30.adjustedHeight)
    
    view.layoutIfNeeded()
  }
  
  private func changeBottomSheet() {
    isBottomSheet = true
    dimView.backgroundColor = Colors.black30.color
    
    rootContainer.pin
      .bottom()
      .height(563.adjustedHeight)
    
    contentContainer.pin
      .bottom(view.pin.safeArea.bottom)
    
    contentContainer.flex
      .markDirty()
      .marginTop(0)
      .marginBottom(view.pin.safeArea.bottom)
      .layout()
    
    rootContainer.flex
      .markDirty()
      .height(563.adjustedHeight)
      .marginBottom(0)
    
    submitButton.flex
      .marginBottom(30.adjustedHeight)
    
    rootContainer.flex
      .layout()
    
  }
  
  
  // MARK: - Animations
  
  private func animateSheetUp() {
    UIView.animate(withDuration: 0.3) {
      self.dimView.alpha = 1
      self.rootContainer.pin
        .bottom(0)
      self.rootContainer.flex
        .layout()
    }
  }
  
  private func animateSheetDown(completion: (() -> Void)? = nil) {
    UIView.animate(withDuration: 0.3, animations: {
      self.rootContainer.pin
        .bottom(-self.rootContainer.frame.height)
      self.rootContainer.flex
        .layout()
    }, completion: { _ in
      completion?()
    })
  }
  
  private func updateSheetPosition(_ position: CGFloat) {
    if position > 0 {
      rootContainer.pin
        .bottom(-position)
    } else {
      animateSheetUp()
    }
  }
}

// MARK: - Binding

extension ReportDetailViewControllerImp: View {
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  public func bindAction(reactor: R) {
    changePanGesture
      .map {
        Reactor.Action.didPan(
          translation: $0.0,
          velocity: $0.1
        )
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    endPanGesture
      .map {
        Reactor.Action.didEndPan(velocity: $0)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    sheetDownEvent
      .map { Reactor.Action.tapDimView }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    navigation.leftItems?[0].rx.tapped
      .map { Reactor.Action.backButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.sheetPosition }
      .distinctUntilChanged()
      .subscribe(with: self, onNext: { owner, position in
        owner.updateSheetPosition(position)
      })
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    navigation.rx
      .panGesture()
      .asObservable()
      .subscribe(with: self, onNext: { owner, gesture in
        guard owner.isBottomSheet else { return }
        
        let translation = gesture.translation(in: owner.rootContainer)
        let velocity = gesture.velocity(in: owner.rootContainer)
        switch gesture.state {
        case .changed:
          owner.changePanGesture.accept((translation, velocity))
        case .ended:
          owner.endPanGesture.accept(velocity)
        default:
          break
        }
      })
      .disposed(by: disposeBag)
    
    dimView.rx.tapGesture { gestureRecognizer, delegate in
      delegate.simultaneousRecognitionPolicy = .always
      gestureRecognizer.cancelsTouchesInView = false // 터치가 뷰로 전달되도록 허용
    }
    .when(.recognized)
    .withUnretained(self)
    .filter { owner, gesture in
      let location = gesture.location(in: self.view)
      return !owner.rootContainer.frame.contains(location)
    }
    .subscribe(with: self, onNext: { owner, _ in
      owner.animateSheetDown {
        owner.sheetDownEvent.accept(())
      }
    })
    .disposed(by: disposeBag)
    
    rootContainer.rx.tapped
      .bind(with: self) { owner, _ in
        owner.textView.textEndEditing.accept(true)
      }
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
      .bind(with: self) { owner, _ in
        owner.changeFullPage()
      }
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
      .bind(with: self) { owner, _ in
        owner.changeBottomSheet()
      }
      .disposed(by: disposeBag)
  }
}
