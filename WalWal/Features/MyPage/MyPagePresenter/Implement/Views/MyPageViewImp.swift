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
import Utility

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
    profileImage: ResourceKitAsset.Assets.yellowDog.image,
    name: " ",
    chipStyle: isFeedProfile ? .none : .tonal,
    chipTitle: isFeedProfile ? "" : "수정",
    isOther: isFeedProfile,
    missionCount: missionCount
  )
  
  // MARK: - Properties
  
  public var disposeBag = DisposeBag()
  public var mypageReactor: R
  private var isFeedProfile: Bool = false
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
        leftItemSize: 40.adjusted,
        title: self.nickname,
        rightItems: []
      ) :
      .init(
        leftItems: [],
        title: "내 정보",
        rightItems: [.setting],
        rightItemSize: 40.adjusted
      )
    self.isFeedProfile = isOther
    
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
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if isFeedProfile {
      containerView.pin
        .top(view.pin.safeArea)
        .left()
        .right()
        .bottom()
    } else {
      containerView.pin
        .all(view.pin.safeArea)
    }
    containerView.flex
      .layout()
  }
  
  // MARK: - Methods
  
  public func setAttribute() {
    navigationBar.backgroundColor = Colors.white.color
    view.backgroundColor = Colors.white.color
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
    /// 공통 액션
    calendar.selectedDayData
      .withUnretained(self)
      .map { owner, calendar in
        Reactor.Action.didSelectCalendarItem(
          memberId: owner.memberId,
          memberNickname: owner.nickname,
          calendar: calendar
        )
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
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
    
    /// 다른 사람 프로필인 경우 네비게이션 액션
    if !isFeedProfile {
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
    
  }
  
  public func bindState(reactor: R) {
    
    reactor.state
      .map { $0.calendarData }
      .distinctUntilChanged()
      .bind(to: calendar.rx.updateModels)
      .disposed(by: disposeBag)
    
    if !isFeedProfile{
      
      reactor.state
        .map { $0.profileData }
        .compactMap { $0 }
        .bind(with: self) { owner, profileData in
          var image: UIImage?
          if let imgName = profileData.defaultImageName,
             let defaultImage = DefaultProfile(rawValue: imgName) {
            image = defaultImage.image
          }
          owner.profileCardView.changeProfileInfo(
            nickname: profileData.nickname,
            image: profileData.profileImage ?? image,
            raisePet: profileData.raisePet
          )
        }
        .disposed(by: disposeBag)
      
    } else {
      Observable
        .combineLatest(
          reactor.state.map { $0.missionCount },
          reactor.state.map { $0.profileData }.compactMap { $0 }
        )
        .bind(with: self) { owner, combinedData in
          let (missionCount, profileData) = combinedData
          var image: UIImage?
          if let imgName = profileData.defaultImageName,
             let defaultImage = DefaultProfile(rawValue: imgName) {
            image = defaultImage.image
          }
          owner.profileCardView.changeProfileInfo(
            nickname: profileData.nickname,
            image: profileData.profileImage ?? image,
            raisePet: profileData.raisePet,
            missionCount: missionCount
          )
        }
        .disposed(by: disposeBag)
      
      
      reactor.state
        .map { $0.calendarData }
        .distinctUntilChanged()
        .bind(to: calendar.rx.updateModels)
        .disposed(by: disposeBag)
      
    }
    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(with: self) { owner, isLoading in
        print("isLoading: \(isLoading)")
        owner.calendar.isHidden = isLoading
        owner.profileCardView.isHidden = isLoading
        ActivityIndicator.shared.showIndicator.accept(isLoading)
      }
      .disposed(by: disposeBag)
    
    
  }
  
  public func bindEvent() {
    
  }
}
