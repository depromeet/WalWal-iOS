//
//  AuthCoordinatorImp.swift
//
//  Auth
//
//  Created by Jiyeon
//

import UIKit
import AuthDependencyFactory
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
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  
  public var authDependencyFactory: AuthDependencyFactory
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    authDependencyFactory: AuthDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.authDependencyFactory = authDependencyFactory
    bindChildToParentAction()
    bindState()
  }
  
  public func bindState() {
//    destination
//      .subscribe(with: self, onNext: { owner, flow in
//        switch flow { }
//      })
//      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, Auth이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    
  }
  
  public func start() {
    let reactor = authDependencyFactory.makeAuthReactor(coordinator: self)
    let authVC = authDependencyFactory.makeAuthViewController(reactor: reactor)
    self.baseViewController = authVC
    self.pushViewController(viewController: authVC, animated: false)
  }
}

// MARK: - Handle Child Actions

extension AuthCoordinatorImp {
  
}

// MARK: - Create and Start(Show) with Flow(View)

extension AuthCoordinatorImp {
  
}

// MARK: - Auth(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension AuthCoordinatorImp {
  
}
