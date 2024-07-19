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
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private let progressView = ProgressView(index: 1)
  private let titleLabel = UILabel().then {
    $0.text = "어떤 반려동물을\n키우고 계신가요?"
    $0.numberOfLines = 2
    $0.font = .boldSystemFont(ofSize: 24)
    $0.textColor = .black
  }
  private let dogView = PetView(petType: .dog)
  private let catView = PetView(petType: .cat)
  private let nextButton = NextButton(isEnable: false)
  
  
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
  
  // MARK: - Layout
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootContainer.pin.all(view.pin.safeArea)
    rootContainer.flex.layout()
  }
  
  public func setAttribute() {
    view.backgroundColor = .white
    view.addSubview(rootContainer)
  }
  
  public func setLayout() {
    rootContainer.flex.justifyContent(.center).marginHorizontal(20).define { flex in
      flex.addItem(progressView).marginTop(32)
      
      flex.addItem().justifyContent(.start).grow(1).define { flex in
        flex.addItem(titleLabel).marginTop(48)
        
        flex.addItem().direction(.row).marginTop(40).define { flex in
          flex.addItem(dogView).grow(1)
          flex.addItem(catView).grow(1).marginLeft(20)
        }
      }
      
      flex.addItem(nextButton).marginBottom(30).height(56)
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
    
  }
  
  public func bindState(reactor: R) {
    
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
