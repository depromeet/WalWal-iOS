//
//  MyPageViewControllerImp.swift
//
//  MyPage
//
//  Created by 조용인
//

import UIKit
import MyPageDomain
import MyPagePresenter

import DesignSystem
import ResourceKit
import GlobalState

import Then
import PinLayout
import FlexLayout
import ReactorKit
import RxSwift
import RxCocoa

public final class MyPageViewControllerImp<R: MyPageReactor>: UIViewController, MyPageViewController {
  
  private typealias Images = ResourceKitAsset.Assets
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.backgroundColor = Colors.gray100.color
  }
  
  private let navigationBar = WalWalNavigationBar(
    leftItems: [],
    title: "내 정보",
    rightItems: [.setting],
    rightItemSize: 40
  ).then { $0.backgroundColor = Colors.white.color }
  
  private let seperator = UIView().then {
    $0.backgroundColor = Colors.gray150.color
  }
  
  private let calendar = WalWalCalendar(initialModels: [])
  
  private lazy var profileCardView = WalWalProfileCardView(
    profileImage: ResourceKitAsset.Sample.calendarCellSample.image,
    name: " ",
    chipStyle: .tonal,
    chipTitle: "수정"
  )
  
  public var disposeBag = DisposeBag()
  public var mypageReactor: R
  
  private var memberInfo: MemberModel = .init(global: GlobalState.shared.profileInfo.value)
  
  public init(
    reactor: R
  ) {
    self.mypageReactor = reactor
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.reactor = mypageReactor
    setAttribute()
    setLayout()
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
    view.backgroundColor = Colors.white.color
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
    calendar.selectedDayData
      .map {
        return Reactor.Action.didSelectCalendarItem(memberInfo: self.memberInfo, date: $0.date)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    navigationBar.rightItems?[0].rx.tapped
      .map {
        Reactor.Action.didTapSettingButton
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    profileCardView.rx.chipTapped
      .map {
        Reactor.Action.didTapEditButton
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    reactor.state.map { $0.calendarData }
      .distinctUntilChanged()
      .bind(to: calendar.rx.updateModels)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.profileData }
      .compactMap { $0 }
      .bind(with: self) { owner, data in
        owner.profileCardView.changeProfileInfo(
          nickname: data.nickname,
          image: data.profileImage,
          raisePet: data.raisePet
        )
      }
      .disposed(by: disposeBag)
  }
  
  public func bindEvent() {
    
  }
}
