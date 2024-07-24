//
//  OnboardingCoordinatorImp.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import UIKit
import DependencyFactory
import BaseCoordinator
import OnboardingCoordinator

import RxSwift
import RxCocoa

public final class OnboardingCoordinatorImp: OnboardingCoordinator {
  
  public typealias Action = OnboardingCoordinatorAction
  public typealias Flow = OnboardingCoordinatorFlow
  
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
        switch flow { 
        case .showSelect:
          owner.showOnboardingSelect()
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, Onboarding이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    
  }
  
  public func start() {
    let reactor = dependencyFactory.makeOnboardingReactor(coordinator: self)
    let onboardingVC = dependencyFactory.makeOnboardingViewController(reactor: reactor)
    self.baseViewController = onboardingVC
    navigationController.pushViewController(onboardingVC, animated: false)
//    self.pushViewController(viewController: onboardingVC, animated: false)
    
  }
}

// MARK: - Handle Child Actions

extension OnboardingCoordinatorImp {
  
  fileprivate func handleOnboardingEvent(_ event: CoordinatorEvent<OnboardingCoordinatorAction>) {
    switch event {
    case .finished:
      childCoordinator = nil
    case .requireParentAction(let action):
      switch action { }
    }
  }
}

// MARK: - Create and Start(Show) with Flow(View)

extension OnboardingCoordinatorImp {
  fileprivate func showOnboardingSelect() {
    let reactor = dependencyFactory.makeOnboardingReactor(coordinator: self)
    let vc = dependencyFactory.makeOnboardingSelectViewController(reactor: reactor)
    navigationController.pushViewController(vc, animated: true)
//    self.pushViewController(viewController: vc, animated: false)
  }
  fileprivate func showNext() {
    let reactor = dependencyFactory.makeOnboardingReactor(coordinator: self)
    let vc = dependencyFactory.makeOnboardingViewController(reactor: reactor)
    navigationController.pushViewController(vc, animated: true)
//    self.pushViewController(viewController: vc, animated: false)
  }
}

// MARK: - Onboarding(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension OnboardingCoordinatorImp {
  
}
