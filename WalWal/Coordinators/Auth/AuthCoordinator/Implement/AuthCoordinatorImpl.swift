//
//  AuthCoordinatorImp.swift
//
//  Auth
//
//  Created by Jiyeon
//

import UIKit
import DependencyFactory
import BaseCoordinator
import AuthCoordinator

import RxSwift
import RxCocoa

public final class AuthCoordinatorImp: AuthCoordinator {
  
  public typealias Action = AuthCoordinatorAction
  public typealias Flow = AuthCoordinatorFlow
  
  public let disposeBag = DisposeBag()
  public let destination = PublishSubject<Flow>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  public var dependencyFactory: DependencyFactory
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    dependencyFactory: DependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.dependencyFactory = dependencyFactory
    bindChildToParentAction()
    bindState()
  }
  
  public func bindState() {
    destination
      .subscribe(with: self, onNext: { owner, flow in
        switch flow { }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, Auth이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    if let AuthEvent = event as? CoordinatorEvent<AuthCoordinatorAction> {
      handleAuthEvent(AuthEvent)
    } else if let AuthEvent = event as? CoordinatorEvent<AuthCoordinatorAction> {
      handleAuthEvent(AuthEvent)
    }
  }
  
  public func start() {
    /// 이런 Reactor랑 ViewController가 있다 치고~
    /// 다만, 해당 ViewController가 이 Coordinator의 Base역할을 하기 때문에, 이 ViewController에 해당하는 Reactor에 Coordinator를 주입 합니다.
    let reactor = dependencyFactory.makeAuthReactor(coordinator: self)
    let authVC = dependencyFactory.makeAuthViewController(reactor: reactor)
    self.baseViewController = authVC
    self.pushViewController(viewController: authVC, animated: false)
  }
}

// MARK: - Handle Child Actions

extension AuthCoordinatorImp {
  
  fileprivate func handleAuthEvent(_ event: CoordinatorEvent<AuthCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action { }
    }
  }
}

// MARK: - Create and Start(Show) with Flow(View)

extension AuthCoordinatorImp {
  
  /// 새로운 Coordinator를 통해서 새로운 Flow를 생성하기 때문에, start를 prefix로 사용합니다.
  fileprivate func startAuth() {
    let AuthCoordinator = dependencyFactory.makeAuthCoordinator(
      navigationController: navigationController
    )
    childCoordinator = AuthCoordinator
    AuthCoordinator.start()
  }
  
  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  fileprivate func showAuth() {
    let reactor = dependencyFactory.makeAuthReactor(coordinator: self)
    let AuthVC = dependencyFactory.makeAuthViewController(reactor: reactor)
    self.pushViewController(viewController: AuthVC, animated: false)
  }
}



// MARK: - Auth(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension AuthCoordinatorImp {
  
}
