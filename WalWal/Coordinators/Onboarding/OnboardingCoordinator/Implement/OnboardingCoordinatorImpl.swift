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

public enum OnboardingCoordinatorAction: ParentAction {
  
}

public enum OnboardingCoordinatorFlow: CoordinatorFlow {
  
}

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
        switch flow { }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, Onboarding이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    if let OnboardingEvent = event as? CoordinatorEvent<OnboardingCoordinatorAction> {
      handleOnboardingEvent(OnboardingEvent)
    } else if let OnboardingEvent = event as? CoordinatorEvent<OnboardingCoordinatorAction> {
      handleOnboardingEvent(OnboardingEvent)
    }
  }
  
  public func start() {
    /// 이런 Reactor랑 ViewController가 있다 치고~
    /// 다만, 해당 ViewController가 이 Coordinator의 Base역할을 하기 때문에, 이 ViewController에 해당하는 Reactor에 Coordinator를 주입 합니다.
    let reactor = dependencyFactory.makeOnboardingReactor(coordinator: self)
    let OnboardingVC = dependencyFactory.makeOnboardingViewController(reactor: reactor)
    self.baseViewController = OnboardingVC
    self.pushViewController(viewController: OnboardingVC, animated: false)
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
  
  /// 새로운 Coordinator를 통해서 새로운 Flow를 생성하기 때문에, start를 prefix로 사용합니다.
  fileprivate func startOnboarding() {
    let onboardingCoordinator = dependencyFactory.makeOnboardingCoordinator(
      navigationController: navigationController, parentCoordinator: nil
    )
    childCoordinator = onboardingCoordinator
    onboardingCoordinator.start()
  }
  
  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  fileprivate func showOnboarding() {
    let reactor = dependencyFactory.makeOnboardingReactor(coordinator: self)
    let OnboardingVC = dependencyFactory.makeOnboardingViewController(reactor: reactor)
    self.pushViewController(viewController: OnboardingVC, animated: false)
  }
}



// MARK: - Onboarding(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension OnboardingCoordinatorImp {
  
}
