//
//  SampleAppCoordinatorImpl.swift
//
//  SampleApp
//
//  Created by 조용인
//

import UIKit
import Utility
import DependencyFactory
import SampleAppCoordinator

import RxSwift
import RxCocoa

public enum SampleAppCoordinatorAction: ParentAction {
  case never
}

public enum SampleAppCoordinatorFlow: CoordinatorFlow {
  case startAuth
  case startHome
}

public final class SampleAppCoordinatorImpl: SampleAppCoordinator {
  
  public typealias Action = SampleAppCoordinatorAction
  public typealias Flow = SampleAppCoordinatorFlow
  
  public let disposeBag = DisposeBag()
  public let destination = PublishSubject<Flow>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public let dependency: DependencyFactory
  public weak var parentCoordinator: (any CoordinatorType)?
  public var childCoordinator: (any CoordinatorType)?
  public var baseViewController: UIViewController?
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any CoordinatorType)?,
    dependency: DependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.dependency = dependency
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
          owner.startHome()
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, SampleApp이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  func handleChildEvent<T: ParentAction>(_ event: T) {
    if let authEvent = event as? CoordinatorEvent<SampleAuthCoordinatorAction> {
      handleAuthEvent(authEvent)
    } else if let homeEvent = event as? CoordinatorEvent<SampleHomeCoordinatorAction> {
      handleHomeEvent(homeEvent)
    }
  }
  
  public func start() {
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

extension SampleAppCoordinatorImpl {
  
  fileprivate func handleAuthEvent(_ event: CoordinatorEvent<SampleAuthCoordinatorAction>) {
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
  
  fileprivate func handleHomeEvent(_ event: CoordinatorEvent<SampleHomeCoordinatorAction>) {
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

extension SampleAppCoordinatorImpl {
  
  /// 새로운 Coordinator를 통해서 새로운 Flow를 생성하기 때문에, start를 prefix로 사용합니다.
  fileprivate func startAuth() {
    let authCoordinator = SampleAuthCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      dependency: dependency
    )
    childCoordinator = authCoordinator
    authCoordinator.start()
  }
  
  /// 새로운 Coordinator를 통해서 Flow를 새로 생성하기 때문에, start를 prefix로 사용합니다.
  fileprivate func startHome() {
    let homeCoordinator = SampleHomeCoordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      dependency: dependency
    )
    childCoordinator = homeCoordinator
    homeCoordinator.start()
  }
}



// MARK: - SampleApp(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension SampleAppCoordinatorImpl {
  /// AppCoordinator는 최상위 부모이기 때문에, 따로 구현하지 않아도 괜찮음.
}
