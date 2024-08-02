//
//  OnboardingViewImp.swift
//  AuthPresenter
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import AuthPresenter
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class OnboardingViewControllerImp<R: OnboardingReactor>: UIViewController, OnboardingViewController, UIScrollViewDelegate {
  typealias Color = ResourceKitAsset.Colors
  typealias Font = ResourceKitFontFamily.KR
  
  public var disposeBag = DisposeBag()
  private var onboardingReactor: R
  
  // MARK: - Initialize
  
  private let rootContainer = UIView()
  private let descriptionView1 = DescriptionView(mainTitle: "반려동물과 함께하는\n데일리 미션", subText: "반려동물과 함께 미션을 수행해요", image: nil)
  private let descriptionView2 = DescriptionView(mainTitle: "귀여운 반려동물\n피드에서 모아보세요!", subText: "다양한 반려동물을 한 눈에 발견해요", image: nil)
  private let descriptionView3 = DescriptionView(mainTitle: "매일 수행한 미션\n언제든지 꺼내봐요!", subText: "반려동물과의 함께한 추억을 기억해요", image: nil)
  private lazy var scrollView = UIScrollView().then {
    $0.isPagingEnabled = true
    $0.showsHorizontalScrollIndicator = false
    $0.bounces = false
    $0.delegate = self
  }
  private lazy var pageControl = UIPageControl().then {
    $0.numberOfPages = 3
    $0.currentPage = 0
    $0.pageIndicatorTintColor = Color.gray300.color
    $0.currentPageIndicatorTintColor = Color.gray600.color
    $0.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
  }
  private let nextButton = CompleteButton(isEnable: true)
  
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
    
    scrollView.contentSize = CGSize(
      width: scrollView.frame.width * 3,
      height: scrollView.frame.height
    )
    scrollView.flex.layout(mode: .adjustHeight)
  }
  
  public func setAttribute() {
    view.backgroundColor = .white
    view.addSubview(rootContainer)
  }
  
  public func setLayout() {
    rootContainer.flex
      .define {
        $0.addItem()
          .justifyContent(.center)
          .grow(1)
          .define {
            $0.addItem(scrollView)
              .alignSelf(.center)
            $0.addItem(pageControl)
              .marginTop(57.adjustedHeight)
              .height(5)
          }
        $0.addItem(nextButton)
          .marginBottom(30)
          .marginHorizontal(20.adjustedWidth)
          .height(56)
      }
    
    scrollView.flex
      .direction(.row)
      .define {
        $0.addItem(descriptionView1)
          .width(100%)
          .height(80%)
        $0.addItem(descriptionView2)
          .width(100%)
          .height(80%)
        $0.addItem(descriptionView3)
          .width(100%)
          .height(80%)
      }
  }
  
  // MARK: - ScrollView Delegate
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView.frame.width > 0 else { return }
    let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
    pageControl.currentPage = Int(pageIndex)
  }
  
}

// MARK: - Binding

extension OnboardingViewControllerImp: View {
  public func bind(reactor: R) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindEvent()
  }
  
  public func bindAction(reactor: R) {
    nextButton.rx.tap
      .map { Reactor.Action.nextButtonTapped(flow: .showSelect) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    
  }
}
