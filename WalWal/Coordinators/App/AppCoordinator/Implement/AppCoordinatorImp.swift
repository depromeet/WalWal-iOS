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
import OnboardingDependencyFactory
import AuthDependencyFactory
import WalWalTabBarDependencyFactory
import MissionDependencyFactory
import MissionUploadDependencyFactory
import FeedDependencyFactory
import FCMDependencyFactory
import MyPageDependencyFactory
import RecordsDependencyFactory
import ImageDependencyFactory
import MembersDependencyFactory

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

  private let appDependencyFactory: SplashDependencyFactory
  private let authDependencyFactory: AuthDependencyFactory
  private let walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory
  private let missionDependencyFactory: MissionDependencyFactory
  private let missionUploadDependencyFactory: MissionUploadDependencyFactory
  private let myPageDependencyFactory: MyPageDependencyFactory
  private let fcmDependencyFactory: FCMDependencyFactory
  private let imageDependencyFactory: ImageDependencyFactory
  private let onboardingDependencyFactory: OnboardingDependencyFactory
  private let feedDependencyFactory: FeedDependencyFactory
  private let recordsDependencyFactory: RecordsDependencyFactory
  private let memberDependencyFactory: MembersDependencyFactory
  
  /// 이곳에서 모든 Feature관련 Dependency의 인터페이스를 소유함.
  /// 그리고 하위 Coordinator를 생성할 때 마다, 하위에 해당하는 인터페이스 모두 전달
  public required init(
    navigationController: UINavigationController,
    appDependencyFactory: SplashDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    walwalTabBarDependencyFactory: WalWalTabBarDependencyFactory,
    missionDependencyFactory: MissionDependencyFactory,
    missionUploadDependencyFactory: MissionUploadDependencyFactory,
    myPageDependencyFactory: MyPageDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory,
    onboardingDependencyFactory: OnboardingDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    recordsDependencyFactory: RecordsDependencyFactory,
    memberDependencyFactory: MembersDependencyFactory
  ) {
    self.navigationController = navigationController
    self.appDependencyFactory = appDependencyFactory
    self.authDependencyFactory = authDependencyFactory
    self.walwalTabBarDependencyFactory = walwalTabBarDependencyFactory
    self.missionDependencyFactory = missionDependencyFactory
    self.missionUploadDependencyFactory = missionUploadDependencyFactory
    self.myPageDependencyFactory = myPageDependencyFactory
    self.fcmDependencyFactory = fcmDependencyFactory
    self.imageDependencyFactory = imageDependencyFactory
    self.onboardingDependencyFactory = onboardingDependencyFactory
    self.feedDependencyFactory = feedDependencyFactory
    self.recordsDependencyFactory = recordsDependencyFactory
    self.memberDependencyFactory = memberDependencyFactory
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
    let removeGlobalCalendarRecordsUseCase = recordsDependencyFactory.injectRemoveGlobalCalendarRecordsUseCase()
    let memberInfoUseCase = memberDependencyFactory.injectMemberInfoUseCase()
    let reactor = appDependencyFactory.injectSplashReactor(
      coordinator: self,
      checkTokenUseCase: checkTokenUseCase,
      checkIsFirstLoadedUseCase: checkIsFirstLoadedUseCase,
      fcmSaveUseCase: fcmSaveUseCase,
      checkRecordCalendarUseCase: checkRecordCalendarUseCase,
      removeGlobalCalendarRecordsUseCase: removeGlobalCalendarRecordsUseCase,
      memberInfoUseCase: memberInfoUseCase
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
      fcmDependencyFactory: fcmDependencyFactory,
      recordsDependencyFactory: recordsDependencyFactory,
      membersDependencyFactory: memberDependencyFactory
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
      missionUploadDependencyFactory: missionUploadDependencyFactory,
      myPageDependencyFactory: myPageDependencyFactory,
      feedDependencyFactory: feedDependencyFactory,
      fcmDependencyFactory: fcmDependencyFactory,
      authDependencyFactory: authDependencyFactory,
      recordDependencyFactory: recordsDependencyFactory, 
      imageDependencyFactory: imageDependencyFactory,
      membersDependencyFactory: memberDependencyFactory
    )
    childCoordinator = walwalTabBarCoordinator
    walwalTabBarCoordinator.start()
  }
  
  private func startOnboarding() {
    let onboardingCoordinator = onboardingDependencyFactory.makeOnboardingCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      fcmDependencyFactory: fcmDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      authDependencyFactory: authDependencyFactory,
      membersDependencyFactory: memberDependencyFactory
    )
    childCoordinator = onboardingCoordinator
    onboardingCoordinator.start()
  }
}



// MARK: - App(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension AppCoordinatorImp {
  /// AppCoordinator는 최상위 부모이기 때문에, 따로 구현하지 않아도 괜찮음.
}
