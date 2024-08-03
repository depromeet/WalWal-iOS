//
//  MyPageViewControllerImp.swift
//
//  MyPage
//
//  Created by 조용인
//


import UIKit
import MyPagePresenter
import DesignSystem
import ResourceKit

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class MyPageViewControllerImp<R: MyPageReactor>: UIViewController, MyPageViewController {
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.gray100.color
  }
  
  private let navigationBar = WalWalNavigationBar(
    leftItems: [],
    title: "내 정보",
    rightItems: [.setting]
  ).then { $0.backgroundColor = ResourceKitAsset.Colors.white.color }
  
  private let seperator = UIView().then {
    $0.backgroundColor = ResourceKitAsset.Colors.gray150.color
  }
  
  private let calendar = WalWalCalendar(initialModels: [])
  
  private let profileCardView = WalWalProfileCardView(
    profileImage: ResourceKitAsset.Sample.calendarCellSample.image,
    name: "조용인",
    subDescription: "안녕하세요 반가워요 👍🏻",
    chipStyle: .tonal,
    chipTitle: "눌러봐",
    selectedChipStyle: .filled,
    selectedChipTitle: "🔥"
  )
  
  public var disposeBag = DisposeBag()
  public var __reactor: R
  
  public init(
      reactor: R
  ) {
    self.__reactor = reactor
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
    self.reactor = __reactor
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    containerView
      .pin
      .all(view.pin.safeArea)
    containerView
      .flex
      .layout()
  }
   
  // MARK: - Methods
  
  
  public func setAttribute() {
    view.backgroundColor = ResourceKitAsset.Colors.white.color
  }
  
  public func setLayout() {
    view.addSubview(containerView)
    
    containerView.flex
      .direction(.column)
      .define { flex in
        flex.addItem(navigationBar)
        flex.addItem(seperator)
          .height(1)
          .width(100%)
        flex.addItem(calendar)
          .grow(1)
        flex.addItem(profileCardView)
      }
  }
}

extension MyPageViewControllerImp: View {
  
  // MARK: - Binding
  
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
    
  }
}
