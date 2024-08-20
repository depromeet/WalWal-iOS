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
import MyPageDependencyFactory
import FeedDependencyFactory
import FCMDependencyFactory
import AuthDependencyFactory
import RecordsDependencyFactory
import MembersDependencyFactory

import BaseCoordinator
import WalWalTabBarCoordinator
import MissionCoordinator
import MyPageCoordinator

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
  
  public var walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory
  public var missionDependencyFactory: MissionDependencyFactory
  public var recordDependencyFactory: RecordsDependencyFactory
  public var myPageDependencyFactory: MyPageDependencyFactory
  public var feedDependencyFactory: FeedDependencyFactory
  private var fcmDependencyFactory: FCMDependencyFactory
  private var authDependencyFactory: AuthDependencyFactory
  private var membersDependencyFactory: MembersDependencyFactory
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory,
    missionDependencyFactory: MissionDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    recordDependencyFactory: RecordsDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.walwalTabBarDependencyFactory = walwalTabBarDependencyFactory
    self.missionDependencyFactory = missionDependencyFactory
    self.myPageDependencyFactory = myPageDependencyFactory
    self.feedDependencyFactory = feedDependencyFactory
    self.fcmDependencyFactory = fcmDependencyFactory
    self.authDependencyFactory = authDependencyFactory
    self.recordDependencyFactory = recordDependencyFactory
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
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, WalWalTabBar이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    if let mypageEvent = event as? MyPageCoordinatorAction {
      handleMypageEvent(.requireParentAction(mypageEvent))
    }
  }
  
  public func start() {
    print("탭바코디네이터 스타트 호출")
    setupTabBarController()
    childCoordinator = tabCoordinators[.startMission]
  }
}

// MARK: - Handle Child Actions

extension WalWalTabBarCoordinatorImp {
  fileprivate func missionEvent(_ event: CoordinatorEvent<MissionCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action { }
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
  
}

// MARK: - Create and Start(Show) with Flow(View)

extension WalWalTabBarCoordinatorImp {
  
  fileprivate func startMission(navigationController: UINavigationController) -> any BaseCoordinator {
    print("미션 탭 선택")
    let missionCoordinator = missionDependencyFactory.injectMissionCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      recordDependencyFactory: recordDependencyFactory
    )
    missionCoordinator.start()
    return missionCoordinator
  }
  
  fileprivate func startFeed(navigationController: UINavigationController) -> any BaseCoordinator {
    print("피드 탭 선택")
    let feedCoordinator = feedDependencyFactory.makeFeedCoordinator(
      navigationController: navigationController,
      parentCoordinator: self
    )
    childCoordinator = feedCoordinator
    feedCoordinator.start()
    return feedCoordinator
  }
  
  /// fileprivate func startNotification() {
  /// print("알림 탭 선택")
  /// let notificationCoordinator = notificationDependencyFactory.makenotificationCoordinator(
  ///   navigationController: navigationController,
  ///   parentCoordinator: self
  /// )
  /// childCoordinator = notificationCoordinator
  /// notificationCoordinator.start()
  /// }
  
  fileprivate func startMyPage(navigationController: UINavigationController) -> any BaseCoordinator{
    print("마이페이지 탭 선택")
    let myPageCoordinator = myPageDependencyFactory.makeMyPageCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      fcmDependencyFactory: fcmDependencyFactory,
      authDependencyFactory: authDependencyFactory,
      membersDependencyFactory: membersDependencyFactory
    )
    myPageCoordinator.start()
    return myPageCoordinator
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
      return startMission(navigationController: navigationController)
    case .startMyPage:
      return startMyPage(navigationController: navigationController)
    }
  }
}
