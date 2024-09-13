//
//  WalWalTabBarCoordinatorImp.swift
//
//  WalWalTabBar
//
//  Created by 조용인
//

import UIKit
import DesignSystem
import WalWalTabBarDependencyFactory
import MissionDependencyFactory
import MissionUploadDependencyFactory
import MyPageDependencyFactory
import FeedDependencyFactory
import FCMDependencyFactory
import AuthDependencyFactory
import RecordsDependencyFactory
import ImageDependencyFactory
import MembersDependencyFactory
import ImageDependencyFactory

import BaseCoordinator
import WalWalTabBarCoordinator
import MissionCoordinator
import FeedCoordinator
import MyPageCoordinator
import FCMCoordinator

import RxSwift
import RxCocoa

public final class WalWalTabBarCoordinatorImp: WalWalTabBarCoordinator {
  
  public typealias Action = WalWalTabBarCoordinatorAction
  public typealias Flow = WalWalTabBarCoordinatorFlow
  
  private let tabBarController: WalWalTabBarViewController
  
  public let disposeBag = DisposeBag()
  public let destination = PublishRelay<Flow>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  private var tabCoordinators: [Flow: any BaseCoordinator] = [:]
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  private let forceMoveTab = PublishRelay<Flow>()
  
  public var walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory
  public var missionDependencyFactory: MissionDependencyFactory
  private let missionUploadDependencyFactory: MissionUploadDependencyFactory
  public var recordDependencyFactory: RecordsDependencyFactory
  public var myPageDependencyFactory: MyPageDependencyFactory
  public var feedDependencyFactory: FeedDependencyFactory
  private var fcmDependencyFactory: FCMDependencyFactory
  private var authDependencyFactory: AuthDependencyFactory
  private let imageDependencyFactory: ImageDependencyFactory
  private var membersDependencyFactory: MembersDependencyFactory
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory,
    missionDependencyFactory: MissionDependencyFactory,
    missionUploadDependencyFactory: MissionUploadDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    recordDependencyFactory: RecordsDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.walwalTabBarDependencyFactory = walwalTabBarDependencyFactory
    self.missionDependencyFactory = missionDependencyFactory
    self.missionUploadDependencyFactory = missionUploadDependencyFactory
    self.myPageDependencyFactory = myPageDependencyFactory
    self.feedDependencyFactory = feedDependencyFactory
    self.fcmDependencyFactory = fcmDependencyFactory
    self.authDependencyFactory = authDependencyFactory
    self.recordDependencyFactory = recordDependencyFactory
    self.imageDependencyFactory = imageDependencyFactory
    self.tabBarController = WalWalTabBarViewController()
    self.membersDependencyFactory = membersDependencyFactory
    
    bindChildToParentAction()
    bindState()
  }
  
  public func bindState() {
    self.tabBarController.selectedFlow
      .subscribe(with: self, onNext: { owner, idx in
        let tabBarItem = Flow(rawValue: idx) ?? .startMission
        owner.destination.accept(tabBarItem)
      })
      .disposed(by: disposeBag)
    
    self.destination
      .distinctUntilChanged()
      .subscribe(with: self, onNext: { owner, flow in
        owner.tabBarController.selectedIndex = flow.rawValue
      })
      .disposed(by: disposeBag)
    
    self.forceMoveTab
      .subscribe(with: self) { owner, flow in
        owner.tabBarController.forceMoveTab.accept(flow.rawValue)
      }
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, WalWalTabBar이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    if let mypageEvent = event as? MyPageCoordinatorAction {
      handleMypageEvent(.requireParentAction(mypageEvent))
    } else if let missionEvent = event as? MissionCoordinatorAction {
      handleMissionEvent(.requireParentAction(missionEvent))
    } else if let feedEvent = event as? FeedCoordinatorAction {
      handleFeedEvent(.requireParentAction(feedEvent))
    } else if let fcmEvent = event as? FCMCoordinatorAction {
      handleFCMEvent(.requireParentAction(fcmEvent))
    }
  }
  
  public func start() {
    print("탭바코디네이터 스타트 호출")
    setupTabBarController()
    childCoordinator = tabCoordinators[.startMission]
  }
  
  /// 특정 탭으로 이동 요청
  public func specificTab(flow: Flow) {
    forceMoveTab.accept(flow)
  }
  
}

// MARK: - Handle Child Actions

extension WalWalTabBarCoordinatorImp {
  fileprivate func handleMissionEvent(_ event: CoordinatorEvent<MissionCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action {
      case .startMyPage:
        self.forceMoveTab.accept(.startMyPage)
      }
    }
  }
  
  fileprivate func handleMypageEvent(_ event: CoordinatorEvent<MyPageCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case let .requireParentAction(action):
      switch action {
      case .startAuth:
        startAuth()
      }
    }
  }
  
  fileprivate func handleFeedEvent(_ event: CoordinatorEvent<FeedCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action {
      case .startProfile(let id, let nickname):
        startOtherProfile(memberId: id, nickName: nickname)
      }
    }
  }
  
  fileprivate func handleFCMEvent(_ event: CoordinatorEvent<FCMCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action {
      case .startMission:
        self.forceMoveTab.accept(.startMission)
      case .startFeed:
        self.forceMoveTab.accept(.startFeed)
      }
    }
  }
  
}

// MARK: - Create and Start(Show) with Flow(View)

extension WalWalTabBarCoordinatorImp {
  
  fileprivate func startMission(navigationController: UINavigationController) -> any BaseCoordinator {
    print("미션 탭 선택")
    let missionCoordinator = missionDependencyFactory.injectMissionCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      missionUploadDependencyFactory: missionUploadDependencyFactory,
      recordDependencyFactory: recordDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      fcmDependencyFactory: fcmDependencyFactory
    )
    missionCoordinator.start()
    return missionCoordinator
  }
  
  fileprivate func startFeed(navigationController: UINavigationController) -> any BaseCoordinator {
    print("피드 탭 선택")
    let feedCoordinator = feedDependencyFactory.injectFeedCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      recordsDependencyFactory: recordDependencyFactory
    )
    childCoordinator = feedCoordinator
    feedCoordinator.start()
    return feedCoordinator
  }
  
  fileprivate func startNotification(navigationController: UINavigationController) -> any BaseCoordinator {
    print("알림 탭 선택")
    let fcmCoordinator = fcmDependencyFactory.injectFCMCoordinator(
      navigationController: navigationController,
      parentCoordinator: self
    )
    childCoordinator = fcmCoordinator
    fcmCoordinator.start()
    return fcmCoordinator
  }
  
  fileprivate func startMyPage(navigationController: UINavigationController) -> any BaseCoordinator{
    print("마이페이지 탭 선택")
    let myPageCoordinator = myPageDependencyFactory.makeMyPageCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      fcmDependencyFactory: fcmDependencyFactory,
      authDependencyFactory: authDependencyFactory,
      membersDependencyFactory: membersDependencyFactory,
      feedDependencyFactory: feedDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      recordsDependencyFactory: recordDependencyFactory
    )
    myPageCoordinator.start()
    return myPageCoordinator
  }
  
  fileprivate func startOtherProfile(
    memberId: Int,
    nickName: String
  ) {
    let profileCoordinator = myPageDependencyFactory.makeMyPageCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      fcmDependencyFactory: fcmDependencyFactory,
      authDependencyFactory: authDependencyFactory,
      membersDependencyFactory: membersDependencyFactory,
      feedDependencyFactory: feedDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      recordsDependencyFactory: recordDependencyFactory
    )
    profileCoordinator.startProfile(memberId: memberId, nickName: nickName)
  }
}



// MARK: - WalWalTabBar(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension WalWalTabBarCoordinatorImp {
  public func startAuth() {
    requireParentAction(.startAuth)
  }
}

// MARK: - Private Method

private extension WalWalTabBarCoordinatorImp {
  
  func setupTabBarController() {
    let navigationControllers = Flow.allCases.map { flow in
      let navigationController = createNavigationController()
      let childCoordinator = setupCoordinator(for: flow, with: navigationController)
      tabCoordinators[flow] = childCoordinator
      return navigationController
    }
    self.tabBarController.setViewControllers(navigationControllers, animated: true)
    self.navigationController.setNavigationBarHidden(true, animated: false)
    self.navigationController.viewControllers = [tabBarController]
  }
  
  func createNavigationController() -> UINavigationController {
    let navigationController = UINavigationController()
    navigationController.setNavigationBarHidden(true, animated: false)
    return navigationController
  }
  
  private func setupCoordinator(for flow: Flow, with navigationController: UINavigationController) -> any BaseCoordinator {
    switch flow {
    case .startMission:
      return startMission(navigationController: navigationController)
    case .startFeed:
      return startFeed(navigationController: navigationController)
    case .startNotification:
      return startNotification(navigationController: navigationController)
    case .startMyPage:
      return startMyPage(navigationController: navigationController)
    }
  }
}
