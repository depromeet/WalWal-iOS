//
//  AppCoordinatorImp.swift
//
//  App
//
//  Created by 조용인
//

import UIKit
import BaseCoordinator
import AppCoordinator
import AuthCoordinator
import OnboardingCoordinator
import WalWalTabBarCoordinator

import SplashDependencyFactory
import AuthDependencyFactory
import WalWalTabBarDependencyFactory
import MissionDependencyFactory
import MyPageDependencyFactory
import FCMDependencyFactory
import OnboardingDependencyFactory
import FeedDependencyFactory
import RecordsDependencyFactory
import FCMDependencyFactory

import RxSwift
import RxCocoa

public final class AppCoordinatorImp: AppCoordinator {
  
  public typealias Action = AppCoordinatorAction
  public typealias Flow = AppCoordinatorFlow
  
  public let disposeBag = DisposeBag()
  public let destination = PublishRelay<Flow>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  
  public var appDependencyFactory: SplashDependencyFactory
  public var authDependencyFactory: AuthDependencyFactory
  public var walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory
  public var missionDependencyFactory: MissionDependencyFactory
  public var myPageDependencyFactory: MyPageDependencyFactory
  public var fcmDependencyFactory: FCMDependencyFactory
  public var onboardingDependencyFactory: OnboardingDependencyFactory
  public var feedDependencyFactory: FeedDependencyFactory
  public var recordsDependencyFactory: RecordsDependencyFactory
  
  /// 이곳에서 모든 Feature관련 Dependency의 인터페이스를 소유함.
  /// 그리고 하위 Coordinator를 생성할 때 마다, 하위에 해당하는 인터페이스 모두 전달
  public required init(
    navigationController: UINavigationController,
    appDependencyFactory: SplashDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory,
    missionDependencyFactory: MissionDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    onboardingDependencyFactory: OnboardingDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    recordsDependencyFactory: RecordsDependencyFactory
  ) {
    self.navigationController = navigationController
    self.appDependencyFactory = appDependencyFactory
    self.authDependencyFactory = authDependencyFactory
    self.walwalTabBarDependencyFactory = walwalTabBarDependencyFactory
    self.missionDependencyFactory = missionDependencyFactory
    self.myPageDependencyFactory = myPageDependencyFactory
    self.fcmDependencyFactory = fcmDependencyFactory
    self.onboardingDependencyFactory = onboardingDependencyFactory
    self.feedDependencyFactory = feedDependencyFactory
    self.recordsDependencyFactory = recordsDependencyFactory
    bindChildToParentAction()
    bindState()
  }
  
  public func bindState() {
    destination
      .subscribe(with: self, onNext: { owner, flow in
        switch flow {
        case .startAuth:
          owner.startAuth()
        case .startHome:
          owner.startTabBar()
        case .startOnboarding:
          owner.startOnboarding()
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, App이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    if let authEvent = event as? AuthCoordinatorAction {
      handleAuthEvent(.requireParentAction(authEvent))
    } else if let onboardingEvent = event as? OnboardingCoordinatorAction {
      handleOnboardingEvent(.requireParentAction(onboardingEvent))
    } else if let homeEvent = event as? WalWalTabBarCoordinatorAction {
      handleHomeEvent(.requireParentAction(homeEvent))
    }
  }
  
  public func start() {
    let checkTokenUseCase = appDependencyFactory.injectCheckTokenUseCase()
    let checkIsFirstLoadedUseCase = appDependencyFactory.injectCheckIsFirstLoadedUseCase()
    let fcmSaveUseCase = fcmDependencyFactory.injectFCMSaveUseCase()
    let checkRecordCalendarUseCase = recordsDependencyFactory.injectCheckCalendarRecordsUseCase()
    let reactor = appDependencyFactory.injectSplashReactor(
      coordinator: self,
      checkTokenUseCase: checkTokenUseCase,
      checkIsFirstLoadedUseCase: checkIsFirstLoadedUseCase,
      fcmSaveUseCase: fcmSaveUseCase,
      checkRecordCalendarUseCase: checkRecordCalendarUseCase
    )
    let splashVC = appDependencyFactory.injectSplashViewController(reactor: reactor)
    self.baseViewController = splashVC
    self.pushViewController(viewController: splashVC, animated: false)
  }
}

// MARK: - Handle Child Actions

extension AppCoordinatorImp {
  
  fileprivate func handleAuthEvent(_ event: CoordinatorEvent<AuthCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case let .requireParentAction(action):
      switch action {
      case .startOnboarding:
        destination.accept(.startOnboarding)
      case .startMission:
        destination.accept(.startHome)
      }
    }
  }
  
  private func handleOnboardingEvent(_ event: CoordinatorEvent<OnboardingCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action {
      case .startMission:
        destination.accept(.startHome)
      }
    }
  }
  
  private func handleHomeEvent(_ event: CoordinatorEvent<WalWalTabBarCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case let .requireParentAction(action):
      switch action {
      case .startAuth:
        destination.accept(.startAuth)
      }
    }
  }
}

// MARK: - Create and Start(Show) with Flow(View)

extension AppCoordinatorImp {
  
  /// 새로운 Coordinator를 통해서 새로운 Flow를 생성하기 때문에, start를 prefix로 사용합니다.
  fileprivate func startAuth() {
    let authCoordinator = authDependencyFactory.injectAuthCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      fcmDependencyFactory: fcmDependencyFactory
    )
    childCoordinator = authCoordinator
    authCoordinator.start()
  }
  
  /// 새로운 Coordinator를 통해서 Flow를 새로 생성하기 때문에, start를 prefix로 사용합니다.
  fileprivate func startTabBar() {
    let walwalTabBarCoordinator = walwalTabBarDependencyFactory.makeTabBarCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      missionDependencyFactory: missionDependencyFactory,
      myPageDependencyFactory: myPageDependencyFactory,
      feedDependencyFactory: feedDependencyFactory,
      fcmDependencyFactory: fcmDependencyFactory,
      authDependencyFactory: authDependencyFactory
    )
    childCoordinator = walwalTabBarCoordinator
    walwalTabBarCoordinator.start()
  }
  
  private func startOnboarding() {
    let onboardingCoordinator = onboardingDependencyFactory.makeOnboardingCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      fcmDependencyFactory: fcmDependencyFactory,
      authDependencyFactory: authDependencyFactory
    )
    childCoordinator = onboardingCoordinator
    onboardingCoordinator.start()
  }
}



// MARK: - App(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension AppCoordinatorImp {
  /// AppCoordinator는 최상위 부모이기 때문에, 따로 구현하지 않아도 괜찮음.
}
