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
  typealias Color = ResourceKitAsset.Colors
  typealias Font = ResourceKitFontFamily.KR
  
  public var disposeBag = DisposeBag()
  private var onboardingReactor: R
  /// 현재 뷰가 pop됐을 경우에 선택 값을 리셋하도록 설정하기 위한 이벤트
  private let initState = PublishSubject<Void>()
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let navigationBar = WalWalNavigationBar(leftItems: [.back], leftItemSize: 40, title: nil, rightItems: [])
  private let contentContainer = UIView()
  private let progressView = ProgressView(index: 1)
  private let titleLabel = UILabel().then {
    $0.text = "어떤 반려동물을\n키우고 계신가요?"
    $0.numberOfLines = 2
    $0.font = Font.H3
    $0.textColor = Color.black.color
  }
  private let dogView = PetView(petType: .dog)
  private let catView = PetView(petType: .cat)
  private let nextButton = CompleteButton(isEnable: false)
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
    setAttribute()
    setLayout()
    self.reactor = onboardingReactor
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if self.isMovingToParent {
      permissionView.showAlert()
    }
  }
  
  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    /// navigation view에서 pop되는 경우에만 선택 값을 리셋하도록 설정
    if self.isMovingFromParent {
      initState.onNext(())
    }
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
    [navigationBar, progressView, contentContainer, nextButton].forEach {
      rootContainer.addSubview($0)
    }
  }
  
  public func setLayout() {
    rootContainer.flex
      .justifyContent(.center)
      
    navigationBar.flex
      .width(100%)
    
    progressView.flex
      .marginTop(24.adjustedHeight)
      .marginHorizontal(20)
    
    contentContainer.flex
      .marginHorizontal(20.adjustedWidth)
      .justifyContent(.start)
      .grow(1)
      .define {
        $0.addItem(titleLabel)
          .marginTop(40.adjustedHeight)
        $0.addItem()
          .direction(.row)
          .justifyContent(.spaceEvenly)
          .marginTop(80.adjustedHeight)
          .define {
            $0.addItem(dogView)
              .grow(1)
            $0.addItem(catView)
              .grow(1)
          }
      }
    nextButton.flex
      .marginHorizontal(20.adjustedWidth)
      .marginBottom(30.adjustedHeight)
      .height(56)
  }
}

extension OnboardingSelectViewControllerImp: View {
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    /// 강아지 선택 액션
    let dogViewTapped = dogView.rx.tapped
      .map { _ in return PetType.dog }
    /// 고양이 선택 액션
    let catViewTapped = catView.rx.tapped
      .map { _ in return PetType.cat }
    
    /// 반려동물 선택 뷰 둘 중 하나 탭 시 Action
    Observable.merge(dogViewTapped, catViewTapped)
      .map { petType in
        Reactor.Action.selectAnimal(
          dog: petType == .dog,
          cat: petType == .cat
        )
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    /// pop이 되었을 때 선택을 초기화 시키기 위한 Action
    initState
      .map { Reactor.Action.initSelectView }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    nextButton.rx.tap
      .map { Reactor.Action.nextButtonTapped(flow: .showProfile) }
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
        owner.nextButton.isEnabled = isEnable
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
    
    navigationBar.leftItems?.first?.rx.tapped
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.navigationController?.popViewController(animated: true)
      }
      .disposed(by: disposeBag)
  }
  
}
