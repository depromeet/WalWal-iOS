//
//  OnboardingSelectView.swift
//  OnboardingPresenterImp
//
//  Created by Jiyeon on 7/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import OnboardingPresenter

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture

public final class OnboardingSelectViewController<R: OnboardingReactor>:
  UIViewController,
  OnboardingViewController {
  
  public var disposeBag = DisposeBag()
  private var onboardingReactor: R
  /// 현재 뷰가 pop됐을 경우에 선택 값을 리셋하도록 설정하기 위한 이벤트
  private let initState = PublishSubject<Void>()
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let contentContainer = UIView()
  private let progressView = ProgressView(index: 1)
  private let titleLabel = UILabel().then {
    $0.text = "어떤 반려동물을\n키우고 계신가요?"
    $0.numberOfLines = 2
    $0.font = .boldSystemFont(ofSize: 24)
    $0.textColor = .black
  }
  private let dogView = PetView(petType: .dog)
  private let catView = PetView(petType: .cat)
  private let nextButton = CompleteButton(isEnable: false)
  
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
    rootContainer.addSubview(progressView)
    rootContainer.addSubview(contentContainer)
    rootContainer.addSubview(nextButton)
  }
  
  public func setLayout() {
    rootContainer.flex.justifyContent(.center).marginHorizontal(20)
    
    progressView.flex.marginTop(32)
    nextButton.flex.height(56).marginBottom(30)
    
    setContentLayout()
  }
  
  /// root 내부에 들어가는 ContentContainer의 레이아웃 설정을 위한 메서드
  private func setContentLayout() {
    contentContainer.flex.justifyContent(.start).grow(1).define {
        $0.addItem(titleLabel).marginTop(48)
        
        $0.addItem().direction(.row).marginTop(40).define {
            $0.addItem(dogView).grow(1)
            $0.addItem(catView).marginLeft(20).grow(1)
          }
      }
  }
}

extension OnboardingSelectViewController {
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    /// 강아지 선택 액션
    let dogViewTapped = dogView.rx.tapGesture()
      .when(.recognized)
      .map { _ in return PetType.dog }
    /// 고양이 선택 액션
    let catViewTapped = catView.rx.tapGesture()
      .when(.recognized)
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
  }
  
  public func bindState(reactor: R) {
    reactor.state
      .map { $0.selectedAnimal }
      .asDriver(onErrorJustReturn: (false, false))
      .drive(with: self) { owner, select in
        let (dog, cat) = select
        owner.dogView.isSelected = dog
        owner.catView.isSelected = cat
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
    
  }
  
}
