//
//  MissionUploadCoordinatorImp.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import UIKit
import MissionUploadDependencyFactory
import BaseCoordinator
import MissionUploadCoordinator

import RxSwift
import RxCocoa

public final class MissionUploadCoordinatorImp: MissionUploadCoordinator {
  
  public typealias Action = MissionUploadCoordinatorAction
  public typealias Flow = MissionUploadCoordinatorFlow
  
  public let disposeBag = DisposeBag()
  public let destination = PublishRelay<Flow>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  
  public var MissionUploadDependencyFactory: MissionUploadDependencyFactory
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    MissionUploadDependencyFactory: MissionUploadDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.MissionUploadDependencyFactory = MissionUploadDependencyFactory
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
  /// 여기도, MissionUpload이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
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
    let reactor = dependencyFactory.make__Reactor(coordinator: self)
    let __VC = dependencyFactory.make__ViewController(reactor: reactor)
    self.baseViewController = __VC
    self.pushViewController(viewController: __VC, animated: false)
  }
}

// MARK: - Handle Child Actions

extension MissionUploadCoordinatorImp {
  
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

extension MissionUploadCoordinatorImp {
  
  /// 새로운 Coordinator를 통해서 새로운 Flow를 생성하기 때문에, start를 prefix로 사용합니다.
  fileprivate func start__() {
    let __Coordinator = dependencyFactory.make__Coordinator(
      navigationController: navigationController,
      parentCoordinator: self
    )
    childCoordinator = __Coordinator
    __Coordinator.start()
  }
  
  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  fileprivate func show__() {
    let reactor = dependencyFactory.make__Reactor(coordinator: self)
    let __VC = dependencyFactory.make__ViewController(reactor: reactor)
    self.pushViewController(viewController: __VC, animated: false)
  }
}



// MARK: - MissionUpload(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension MissionUploadCoordinatorImp {
  
}
