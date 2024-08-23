//
//  OnboardingViewControllerImp.swift
//
//  Onboarding
//
//  Created by Jiyeon
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

public final class OnboardingViewControllerImp<R: OnboardingReactor>:
  UIViewController,
  OnboardingViewController,
  UIScrollViewDelegate {
  
  private typealias Images = ResourceKitAsset.Assets
  private typealias Colors = ResourceKitAsset.Colors
  
  public var disposeBag = DisposeBag()
  private var onboardingReactor: R
  
  // MARK: - UI
  
  private let rootContainer = UIView()
  private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout()).then {
    $0.backgroundColor = Colors.white.color
    $0.register(DescriptionCell.self)
    $0.showsHorizontalScrollIndicator = false
    $0.decelerationRate = .fast
    $0.contentInsetAdjustmentBehavior = .never
    $0.isPagingEnabled = true
    $0.bounces = false
  }
  
  private let cellData: [DescriptionModel] = [
    .init(
      title: "반려동물과 함께하는\n데일리 미션",
      subTitle: "반려동물과 함께 미션을 수행해요",
      image: Images.onboarding1.image
    ),
    .init(
      title: "귀여운 반려동물\n피드에서 모아보세요!",
      subTitle: "다양한 반려동물을 한 눈에 발견해요",
      image: Images.onboarding2.image
    ),
    .init(
      title: "매일 수행한 미션\n언제든지 꺼내봐요!",
      subTitle: "반려동물과의 함께한 추억을 기억해요",
      image: Images.onboarding3.image
    )
  ]
  
  private lazy var pageControl = UIPageControl().then {
    $0.numberOfPages = 3
    $0.currentPage = 0
    $0.pageIndicatorTintColor = Colors.gray300.color
    $0.currentPageIndicatorTintColor = Colors.gray600.color
    $0.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
  }
  private let nextButton = WalWalButton(type: .active, title: "시작하기")
  
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
  }
  
  public func configureLayout() {
    rootContainer.flex
      .define {
        $0.addItem()
          .justifyContent(.end)
          .marginBottom(99.adjustedHeight)
          .grow(1)
          .define {
            $0.addItem(collectionView)
              .width(375.adjustedWidth)
              .height(367.adjustedHeight)
            $0.addItem(pageControl)
              .marginTop(22.adjustedHeight)
              .height(5)
          }
        $0.addItem(nextButton)
          .marginBottom(30.adjustedHeight)
          .marginHorizontal(20)
      }
    
  }
  
  private func collectionViewLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 367.adjustedHeight)
    layout.scrollDirection = .horizontal
    return layout
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
    nextButton.rx.tapped
      .map { Reactor.Action.nextButtonTapped(flow: .showSelect) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    
  }
  
  public func bindEvent() {
    
    collectionView.rx.contentOffset
      .withUnretained(self)
      .map { owner, contentOffset -> Int in
        guard owner.collectionView.frame.width > 0 else { return 0 }
        let page = Int(round(contentOffset.x / owner.collectionView.frame.width))
        return page
      }
      .bind(to: pageControl.rx.currentPage)
      .disposed(by: disposeBag)
    
    
    Observable.just(cellData)
      .bind(to: collectionView.rx.items(DescriptionCell.self)) { index, data, cell in
        cell.configData(data: data)
      }
      .disposed(by: disposeBag)
  }
}
