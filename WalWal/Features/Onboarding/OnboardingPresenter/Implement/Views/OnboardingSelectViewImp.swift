//
//  OnboardingSelectViewImp.swift
//  OnboardingPresenter
//
//  Created by Jiyeon on 7/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import OnboardingPresenter
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa


/// 반려동물 선택하는 페이지
public final class OnboardingSelectViewControllerImp<R: OnboardingSelectReactor>:
  UIViewController,
  OnboardingSelectViewController {
  private typealias Color = ResourceKitAsset.Colors
  private typealias Font = ResourceKitFontFamily.KR
  
  public var disposeBag = DisposeBag()
  private var onboardingReactor: R
  private let selectPetType = PublishRelay<String>()
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let navigationBar = WalWalNavigationBar(
    leftItems: [.darkBack],
    leftItemSize: 40,
    title: nil,
    rightItems: []
  )
  private let contentContainer = UIView()
  private let progressView = ProgressView(index: 1)
  private let titleLabel = CustomLabel(
    text: "어떤 반려동물을\n키우고 계신가요?",
    font: Font.H3
  ).then {
    $0.numberOfLines = 2
    $0.textColor = Color.black.color
  }
  private let selectButtonView = UIView()
  private let dogView = PetView(petType: .dog)
  private let catView = PetView(petType: .cat)
  private let nextButton = WalWalButton(type: .disabled, title: "다음")
  private let permissionView = PermissionView()
  
  // MARK: - Initialize
  
  public init(reactor: R) {
    self.onboardingReactor = reactor
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
    self.reactor = onboardingReactor
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if self.isMovingToParent {
      permissionView.showAlert()
    }
  }
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin
      .all(view.pin.safeArea)
    rootContainer.flex
      .layout()
  }
  
  public func configureAttribute() {
    view.backgroundColor = .white
    view.addSubview(rootContainer)
    [navigationBar, progressView, contentContainer, nextButton].forEach {
      rootContainer.addSubview($0)
    }
  }
  
  public func configureLayout() {
    rootContainer.flex
      .justifyContent(.spaceBetween)
    
    navigationBar.flex
      .width(100%)
    
    progressView.flex
      .marginTop(24.adjustedHeight)
      .marginHorizontal(20)
    
    contentContainer.flex
      .marginHorizontal(20.adjustedWidth)
      .marginTop(40.adjustedHeight)
      .justifyContent(.spaceBetween)
      .grow(1)
      .define {
        $0.addItem(titleLabel)
          .height(58.adjustedHeight)
        $0.addItem(selectButtonView)
          .marginTop(80.adjustedHeight)
        $0.addItem()
          .grow(1)
      }
    selectButtonView.flex
      .direction(.row)
      .justifyContent(.center)
      .alignItems(.start)
      .define {
        $0.addItem(dogView)
          .marginRight(15.adjustedWidth)
        $0.addItem(catView)
      }
    
    nextButton.flex
      .marginHorizontal(20.adjustedWidth)
      .marginBottom(32.adjustedHeight)
      .height(56.adjustedHeight)
  }
}

extension OnboardingSelectViewControllerImp: View {
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    let dogViewTapped = dogView.rx.tapped
      .map { _ in return PetType.dog }
    let catViewTapped = catView.rx.tapped
      .map { _ in return PetType.cat }
    
    Observable.merge(dogViewTapped, catViewTapped)
      .withUnretained(self)
      .map { owner, petType in
        owner.selectPetType.accept(petType.rawValue)
        return Reactor.Action.selectAnimal(
          dog: petType == .dog,
          cat: petType == .cat
        )
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    nextButton.rx.tapped
      .withLatestFrom(selectPetType)
      .map { Reactor.Action.nextButtonTapped(flow: .showProfile(petType: $0))}
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    navigationBar.leftItems?.first?.rx.tapped
      .map { Reactor.Action.tapBackButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.selectedAnimal }
      .asDriver(onErrorJustReturn: (nil, nil))
      .drive(with: self) { owner, select in
        if let dog = select.0, let cat = select.1 {
          owner.dogView.isSelected = dog
          owner.catView.isSelected = cat
        }
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.selectCompleteButtonEnable }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, isEnable in
        let isEnable: WalWalButtonType = isEnable ? .active : .disabled
        owner.nextButton.rx.buttonType.onNext(isEnable)
      }
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    dogView.rx.tapGesture()
      .when(.recognized)
      .asDriver(onErrorJustReturn: .init())
      .drive(with: self) { owner, _ in
        owner.dogView.isSelected = true
        owner.catView.isSelected = false
      }
      .disposed(by: disposeBag)
    
    catView.rx.tapGesture()
      .when(.recognized)
      .asDriver(onErrorJustReturn: .init())
      .drive(with: self) { owner, _ in
        owner.dogView.isSelected = false
        owner.catView.isSelected = true
      }
      .disposed(by: disposeBag)
    
  }
  
}
