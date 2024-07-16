//
//  CoordinatorTypeCoordinatorImpl.swift
//
//  CoordinatorType
//
//  Created by 조용인
//

import UIKit
import Utility
import DependencyFactory
import CoordinatorTypeCoordinator

import RxSwift
import RxCocoa

public enum CoordinatorTypeCoordinatorAction: ParentAction {
  
}

public enum CoordinatorTypeCoordinatorFlow: CoordinatorFlow {
  
}

public final class CoordinatorTypeCoordinatorImp: CoordinatorTypeCoordinator {
  
  public typealias Action = CoordinatorTypeCoordinatorAction
  public typealias Flow = CoordinatorTypeCoordinatorFlow
  
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
        switch flow { }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, CoordinatorType이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    if let __Event = event as? CoordinatorEvent<__CoordinatorAction> {
      handle__Event(__Event)
    } else if let __Event = event as? CoordinatorEvent<__CoordinatorAction> {
      handle__Event(__Event)
    }
  }
  
  public func start() {
    /// 이런 Reactor랑 ViewController가 있다 치고~
    /// 다만, 해당 ViewController가 이 Coordinator의 Base역할을 하기 때문에, 이 ViewController에 해당하는 Reactor에 Coordinator를 주입 합니다.
    let __UseCase = dependency.make__UseCase()
    let reactor = __Reactor(
      coordinator: self,
      __UseCase: __UseCase
    )
    let __ViewController = __ViewController(reactor: reactor)
    self.baseViewController = __ViewController
    self.pushViewController(viewController: __ViewController, animated: false)
  }
}

// MARK: - Handle Child Actions

extension CoordinatorTypeCoordinatorImp {
  
  fileprivate func handle__Event(_ event: CoordinatorEvent<__CoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action { }
    }
  }
}

// MARK: - Create and Start(Show) with Flow(View)

extension CoordinatorTypeCoordinatorImp {
  
  /// 새로운 Coordinator를 통해서 새로운 Flow를 생성하기 때문에, start를 prefix로 사용합니다.
  fileprivate func start__() {
    let __Coordinator = __Coordinator(
      navigationController: navigationController,
      parentCoordinator: self,
      dependency: dependency
    )
    childCoordinator = __Coordinator
    __Coordinator.start()
  }
  
  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  fileprivate func show__() {
    let __UseCase = dependency.make__UseCase()
    let reactor = __Reactor(
      coordinator: self,
      __UseCase: __UseCase
    )
    let __VC = __ViewController(reactor: reactor)
    navigationController.pushViewController(__VC, animated: true)
  }
}



// MARK: - CoordinatorType(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension CoordinatorTypeCoordinatorImp {
  
}
