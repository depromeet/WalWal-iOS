//
//  FeedCoordinatorImp.swift
//
//  Feed
//
//  Created by 이지희
//

import UIKit
import DesignSystem
import FeedDependencyFactory
import RecordsDependencyFactory
import FCMDependencyFactory

import BaseCoordinator
import FeedCoordinator

import RxSwift
import RxCocoa

public final class FeedCoordinatorImp: FeedCoordinator {
  
  public typealias Action = FeedCoordinatorAction
  public typealias Flow = FeedCoordinatorFlow
  
  public let disposeBag = DisposeBag()
  public let destination = PublishRelay<Flow>()
  public let doubleTapRelay = PublishRelay<Int>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  
  public var feedDependencyFactory: FeedDependencyFactory
  public var recordsDependencyFactory: RecordsDependencyFactory
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    feedDependencyFactory: FeedDependencyFactory,
    recordsDependencyFactory: RecordsDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.feedDependencyFactory = feedDependencyFactory
    self.recordsDependencyFactory = recordsDependencyFactory
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
  /// 여기도, Feed이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    //    if let __Event = event as? CoordinatorEvent<__CoordinatorAction> {
    //      handle__Event(__Event)
    //    } else if let __Event = event as? CoordinatorEvent<__CoordinatorAction> {
    //      handle__Event(__Event)
    //    }
  }
  
  public func start() {
    let fetchFeedUseCase = feedDependencyFactory.injectFetchFeedUseCase()
    let updateBoostCountUseCase =  recordsDependencyFactory.injectUpdateRecordUseCase()
    let removeGlobalRecordIdUseCase = feedDependencyFactory.injectRemoveGlobalRecordIdUseCase()
    
    let reactor = feedDependencyFactory.injectFeedReactor(
      coordinator: self,
      fetchFeedUseCase: fetchFeedUseCase,
      updateBoostCountUseCase: updateBoostCountUseCase,
      removeGlobalRecordIdUseCase: removeGlobalRecordIdUseCase
    )
    
    let feedVC = feedDependencyFactory.injectFeedViewController(reactor: reactor)
    self.baseViewController = feedVC
    doubleTapRelay
      .subscribe(with: self, onNext: { owner, index in
        reactor.action.onNext(.doubleTap(index))
      })
      .disposed(by: disposeBag)
    
    self.pushViewController(viewController: feedVC, animated: false)
    
  }
}

// MARK: - Handle Child Actions

extension FeedCoordinatorImp {
  
  //  fileprivate func handle__Event(_ event: CoordinatorEvent<__CoordinatorAction>) {
  //    switch event {
  //    case .finished:
  //      childCoordinator = nil
  //    case .requireParentAction(let action):
  //      switch action { }
  //    }
  //  }
}

// MARK: - Create and Start(Show) with Flow(View)

extension FeedCoordinatorImp {
  
  //  /// 새로운 Coordinator를 통해서 새로운 Flow를 생성하기 때문에, start를 prefix로 사용합니다.
  //  fileprivate func start__() {
  //    let feedCoordinator = feedDependencyFactory.make__Coordinator(
  //      navigationController: navigationController,
  //      parentCoordinator: self
  //    )
  //    childCoordinator = __Coordinator
  //    __Coordinator.start()
  //  }
  //
  //  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  //  fileprivate func show__() {
  //    let reactor = dependencyFactory.make__Reactor(coordinator: self)
  //    let __VC = dependencyFactory.make__ViewController(reactor: reactor)
  //    self.pushViewController(viewController: __VC, animated: false)
  //  }
}



// MARK: - Feed(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension FeedCoordinatorImp {
  public func startProfile(memberId: Int, nickName: String) {
    requireParentAction(.startProfile(memberId: memberId, nickName: nickName))
  }
  
  public func doubleTap(index: Int) {
    doubleTapRelay.accept(index)
  }
}
