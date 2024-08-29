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
  
  private typealias Assets = ResourceKitAsset.Assets
  private typealias Images = ResourceKitAsset.Images
  private typealias Colors = ResourceKitAsset.Colors
  private typealias Fonts = ResourceKitFontFamily
  
  // MARK: - UI
  
  private let containerView = UIView().then {
    $0.backgroundColor = Colors.gray100.color
  }
  
  private var navigationBar: WalWalNavigationBar
  
  private let seperator = UIView().then {
    $0.backgroundColor = Colors.gray150.color
  }
  
  private let calendar = WalWalCalendar(initialModels: [])
  
  private lazy var profileCardView = WalWalProfileCardView(
    profileImage: ResourceKitAsset.Sample.calendarCellSample.image,
    name: " ",
    chipStyle: isOtherProfile ? .none : .tonal,
    chipTitle: isOtherProfile ? "" : "수정",
    isOther: isOtherProfile,
    missionCount: missionCount
  )
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  public var mypageReactor: R
  private var isOtherProfile: Bool = false
  private var isMoveToEdit: Bool = false
  private var missionCount = 0
  private let refreshProfileInfo = PublishRelay<Void>()
  
  private var memberInfo: MemberModel = .init(global: GlobalState.shared.profileInfo.value)
  private var nickname: String = ""
  private var memberId: Int = 0
  
  public init(
    reactor: R,
    memberId: Int? = nil,
    nickname: String? = nil,
    isOther: Bool = false
  ) {
    self.nickname = nickname ?? GlobalState.shared.profileInfo.value.nickname
    self.memberId = memberId ?? GlobalState.shared.profileInfo.value.memberId
    self.navigationBar = isOther ?
      .init(
        leftItems: [.darkBack],
        leftItemSize: 40,
        title: self.nickname,
        rightItems: []
      ) :
      .init(
        leftItems: [],
        title: "내 정보",
        rightItems: [.setting],
        rightItemSize: 40
      )
    self.isOtherProfile = isOther
    
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
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if isMoveToEdit {
      isMoveToEdit = false
      refreshProfileInfo.accept(())
    }
    mypageReactor.action.onNext(.loadCalendarData)
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    containerView.pin
      .all(view.pin.safeArea)
    containerView.flex
      .layout()
  }
  
  // MARK: - Methods
  
  public func setAttribute() {
    view.backgroundColor = Colors.gray100.color
  }
  
  public func setLayout() {
    view.addSubview(containerView)
    
    containerView.flex
      .justifyContent(.spaceBetween)
      .define { flex in
        flex.addItem(navigationBar)
        flex.addItem(seperator)
          .height(1)
          .width(100%)
        flex.addItem()
          .grow(1)
          .shrink(1)
          .define {
            $0.addItem(calendar)
          }
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
        Reactor.Action.didSelectCalendarItem(
          memberInfo: self.memberInfo,
          calendar: $0
        )
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    if !isOtherProfile {
      navigationBar.rightItems?[0].rx.tapped
        .map {
          Reactor.Action.didTapSettingButton
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    } else {
      navigationBar.leftItems?[0].rx.tapped
        .map { Reactor.Action.didTapBackButton }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
    
    profileCardView.rx.chipTapped
      .map {
        self.isMoveToEdit = true
        return Reactor.Action.didTapEditButton
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    refreshProfileInfo
      .map { Reactor.Action.loadProfileInfo }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  public func bindState(reactor: R) {
    if isOtherProfile {
      reactor.state.map { $0.calendarData }
        .distinctUntilChanged()
        .bind(to: calendar.rx.updateModels)
        .disposed(by: disposeBag)
      
      reactor.state
        .map { $0.missionCount }
        .bind(with: self) { owner, count in
          owner.profileCardView.changeProfileInfo(
            nickname: owner.nickname,
            image: nil,
            raisePet: "",
            missionCount: count
          )}
        .disposed(by: disposeBag)
      
      reactor.state
        .map { $0.calendarData }
        .distinctUntilChanged()
        .bind(to: calendar.rx.updateModels)
        .disposed(by: disposeBag)
      
      reactor.state
        .map { $0.profileData }
        .compactMap { $0 }
        .bind(with: self) { owner, data in
          var image: UIImage?
          if let imgName = data?.defaultImageName,
             let defaultImage = DefaultProfile(rawValue: imgName) {
            image = defaultImage.image
          }
        }
        .disposed(by: disposeBag)
    } else {
      
      reactor.state.map { $0.calendarData }
        .distinctUntilChanged()
        .bind(to: calendar.rx.updateModels)
        .disposed(by: disposeBag)
      
      reactor.state
        .map { $0.profileData }
        .compactMap { $0 }
        .bind(with: self) { owner, data in
          var image: UIImage?
          if let imgName = data.defaultImageName,
             let defaultImage = DefaultProfile(rawValue: imgName) {
            image = defaultImage.image
          }
          owner.profileCardView.changeProfileInfo(
            nickname: data.nickname,
            image: data.profileImage ?? image,
            raisePet: data.raisePet
          )
        }
        .disposed(by: disposeBag)
    }
  }
  
  public func bindEvent() {
    
  }
}
