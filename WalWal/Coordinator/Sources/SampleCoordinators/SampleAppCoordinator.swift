//
//  AppCoordinator.swift
//  Coordinator
//
//  Created by 조용인 on 7/12/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import Utility
import DependencyFactory

import RxSwift
import RxCocoa

enum SampleAppCoordinatorAction: ParentAction {
  case never
}

enum SampleAppCoordinatorFlow: CoordinatorFlow {
  case startAuth
  case startHome
}

class SampleAppCoordinator: CoordinatorType {
  
  typealias Action = SampleAppCoordinatorAction
  typealias Flow = SampleAppCoordinatorFlow
  
  let disposeBag = DisposeBag()
  let destination = PublishSubject<Flow>()
  let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  let navigationController: UINavigationController
  let dependency: DependencyFactory
  weak var parentCoordinator: (any CoordinatorType)?
  var childCoordinator: (any CoordinatorType)?
  var baseViewController: UIViewController?
  
  required init(
    navigationController: UINavigationController,
    parentCoordinator: (any CoordinatorType)?,
    dependency: DependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = nil
    self.dependency = dependency
    bindChildToParentAction()
    bindState()
  }
  
  func bindState() {
    destination
      .subscribe(with: self, onNext: { owner, flow in
        switch flow {
        case .startAuth:
          owner.startAuth()
        case .startHome:
          owner.startHome()
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  func handleChildEvent<T: ParentAction>(_ event: T) {
    if let authEvent = event as? CoordinatorEvent<SampleAuthCoordinatorAction> {
      handleAuthEvent(authEvent)
    } else if let homeEvent = event as? CoordinatorEvent<SampleHomeCoordinatorAction> {
      handleHomeEvent(homeEvent)
    }
  }
  
  func start() {
    /// 이런 Reactor랑 ViewController가 있다 치고~
    /// 다만, 해당 ViewController가 이 Coordinator의 Base역할을 하기 때문에, 이 ViewController에 해당하는 Reactor에 Coordinator를 주입 합니다.
    let splashUseCase = dependency.makeSplashUseCase()
    let reactor = SplashReactor(
      coordinator: self,
      splashUseCase: splashUseCase
    )
    let splashViewController = SplashViewController(reactor: reactor)
    self.baseViewController = splashViewController
    self.pushViewController(viewController: splashViewController, animated: false)
  }
}

// MARK: - Handle Child Actions

extension SampleAppCoordinator {
  
  private func handleAuthEvent(_ event: CoordinatorEvent<SampleAuthCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action {
      case .authenticationCompleted:
        destination.onNext(.startHome)
      case .authenticationFailed(let error):
        print("Authentication failed: \(error.localizedDescription)")
        /// 에러 처리 로직
      }
    }
  }
  
  private func handleHomeEvent(_ event: CoordinatorEvent<SampleHomeCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action {
      case .logout:
        destination.onNext(.startAuth)
      }
    }
  }
}

// MARK: - Create and Start(Show) with Flow(View)

extension SampleAppCoordinator {
  
  /// 새로운 Coordinator를 통해서 새로운 Flow를 생성하기 때문에, start를 prefix로 사용합니다.
  private func startAuth() {
    let authCoordinator = SampleAuthCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      dependency: dependency
    )
    childCoordinator = authCoordinator
    authCoordinator.start()
  }
  
  /// 새로운 Coordinator를 통해서 Flow를 새로 생성하기 때문에, start를 prefix로 사용합니다.
  private func startHome() {
    let homeCoordinator = SampleHomeCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      dependency: dependency
    )
    childCoordinator = homeCoordinator
    homeCoordinator.start()
  }
}

// MARK: - App(자식)의 동작 결과, ??(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension SampleAppCoordinator {
  /// AppCoordinator는 최상위 부모이기 때문에, 따로 구현하지 않아도 괜찮음.
}
