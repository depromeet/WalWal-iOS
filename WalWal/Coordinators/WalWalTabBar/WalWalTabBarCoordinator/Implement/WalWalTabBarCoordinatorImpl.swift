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
import BaseCoordinator
import WalWalTabBarCoordinator

import RxSwift
import RxCocoa

public final class WalWalTabBarCoordinatorImp: WalWalTabBarCoordinator {
  
  public typealias Action = WalWalTabBarCoordinatorAction
  public typealias Flow = WalWalTabBarCoordinatorFlow
  
  public let tabBarController: WalWalTabBarViewController
  
  public let disposeBag = DisposeBag()
  public let destination = PublishSubject<Flow>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  public var walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  
  private var tabViewControllers: [Flow: UINavigationController] = [:]
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.walwalTabBarDependencyFactory = walwalTabBarDependencyFactory
    self.tabBarController = WalWalTabBarViewController()
    
    bindChildToParentAction()
    bindState()
  }
  
  public func bindState() {
    self.tabBarController.selectedFlow
      .compactMap { Flow(rawValue: $0) }
      .bind(to: destination)
      .disposed(by: disposeBag)
    
    self.destination
      .distinctUntilChanged()
      .subscribe(with: self, onNext: { owner, flow in
        owner.startFlow(flow)
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, WalWalTabBar이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    /// if let missionEvent = event as? CoordinatorEvent<MissonCoordinatorAction> {
    ///   handleMissionEvent(missionEvent)
    /// } else if let feedEvent = event as? CoordinatorEvent<FeedCoordinatorAction> {
    ///   handleFeedEvent(feedEvent)
    /// } else if let notificationEvent = event as? CoordinatorEvent<NotificationCoordinatorAction> {
    ///   handleNotificationEvent(notificationEvent)
    /// } else if let myPageEvent = event as? CoordinatorEvent<MyPageCoordinatorAction> {
    ///   handleMyPageEvent(myPageEvent)
    /// }
  }
  
  public func start() {
    setupTabBarController()
    navigationController.setViewControllers([tabBarController], animated: false)
    startFlow(.startMission) // 초기 탭 설정
  }
  
  public func startFlow(_ flow: Flow) {
    if tabViewControllers[flow] == nil {
      let navController = createNavigationController(for: flow)
      tabViewControllers[flow] = navController
    }
    
    tabBarController.selectedFlow.accept(flow.rawValue)
    
    if childCoordinator == nil {
      startCoordinator(for: flow)
    }
  }
}

// MARK: - Handle Child Actions

extension WalWalTabBarCoordinatorImp {
  /// fileprivate func missionEvent(_ event: CoordinatorEvent<MissonCoordinatorAction>) {
  ///   switch event {
  ///   case .finished:
  ///     childCoordinator = nil
  ///   case .requireParentAction(let action):
  ///     switch action { }
  ///   }
  /// }
  ///
  /// fileprivate func feedEvent(_ event: CoordinatorEvent<FeedCoordinatorAction>) {
  ///   switch event {
  ///   case .finished:
  ///     childCoordinator = nil
  ///   case .requireParentAction(let action):
  ///     switch action { }
  ///   }
  /// }
  ///
  /// fileprivate func notificationEvent(_ event: CoordinatorEvent<NotificationCoordinatorAction>) {
  ///   switch event {
  ///   case .finished:
  ///     childCoordinator = nil
  ///   case .requireParentAction(let action):
  ///     switch action { }
  ///   }
  /// }
  ///
  /// fileprivate func myPageEvent(_ event: CoordinatorEvent<MyPageCoordinatorAction>) {
  ///   switch event {
  ///   case .finished:
  ///     childCoordinator = nil
  ///   case .requireParentAction(let action):
  ///     switch action { }
  ///   }
  /// }
}

// MARK: - Create and Start(Show) with Flow(View)

extension WalWalTabBarCoordinatorImp {
  
  fileprivate func startMission() {
    print("미션 탭 선택")
    /// let missionCoordinator = missionDependencyFactory.makeMissionCoordinator(
    ///   navigationController: navigationController,
    ///   parentCoordinator: self
    /// )
    /// childCoordinator = missionCoordinator
    /// missionCoordinator.start()
  }
  
  fileprivate func startFeed() {
    print("피드 탭 선택")
    /// let feedCoordinator = feedDependencyFactory.makefeedCoordinator(
    ///   navigationController: navigationController,
    ///   parentCoordinator: self
    /// )
    /// childCoordinator = feedCoordinator
    /// feedCoordinator.start()
  }
  
  fileprivate func startNotification() {
    print("알림 탭 선택")
    /// let notificationCoordinator = notificationDependencyFactory.makenotificationCoordinator(
    ///   navigationController: navigationController,
    ///   parentCoordinator: self
    /// )
    /// childCoordinator = notificationCoordinator
    /// notificationCoordinator.start()
  }
  
  fileprivate func startMyPage() {
    print("마이페이지 탭 선택")
    /// let myPageCoordinator = myPageDependencyFactory.makeMyPageCoordinator(
    ///   navigationController: navigationController,
    ///   parentCoordinator: self
    /// )
    /// childCoordinator = myPageCoordinator
    /// myPageCoordinator.start()
  }
  
}



// MARK: - WalWalTabBar(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension WalWalTabBarCoordinatorImp {
  
}

// MARK: - Private Method

private extension WalWalTabBarCoordinatorImp {
  
  func setupTabBarController() {
    Flow.allCases.forEach { flow in
      let navController = createNavigationController(for: flow)
      tabViewControllers[flow] = navController
    }
    tabBarController.setViewControllers(Array(tabViewControllers.values), animated: false)
  }
  
  func createNavigationController(for flow: Flow) -> UINavigationController {
    let navigationController = UINavigationController()
    navigationController.setNavigationBarHidden(true, animated: false)
    return navigationController
  }
  
  func startCoordinator(for flow: Flow) {
    guard let navController = tabViewControllers[flow] else { return }
    
    switch flow {
    case .startMission:
      startMission()
    case .startFeed:
      startFeed()
    case .startNotification:
      startNotification()
    case .startMyPage:
      startMyPage()
    }
  }
}
