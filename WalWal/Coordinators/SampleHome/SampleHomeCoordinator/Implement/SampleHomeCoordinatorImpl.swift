//
//  SampleHomeCoordinatorImpl.swift
//
//  SampleHome
//
//  Created by 조용인
//

import UIKit
import Utility
import DependencyFactory
import SampleHomeCoordinator

import RxSwift
import RxCocoa

public final class SampleHomeCoordinatorImpl: SampleHomeCoordinator {
  
  public typealias Action = SampleHomeCoordinatorAction
  public typealias Flow = SampleHomeCoordinatorFlow
  
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
        case .showProfile:
          owner.showProfile()
        case .showSettings:
          owner.showSettings()
        }
      })
      .disposed(by: disposeBag)
  }
  
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    /// 여기도, Home이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  }
  
  public func start() {
    /// 이런 Reactor랑 ViewController가 있다 치고~
    /// 다만, 해당 ViewController가 이 Coordinator의 Base역할을 하기 때문에, 이 ViewController에 해당하는 Reactor에 Coordinator를 주입 합니다.
    let homeUseCase = dependency.makeHomeUseCase()
    let reactor = HomeMainReactor(
      coordinator: self,
      homeUseCase: homeUseCase
    )
    let homeMainViewController = HomeMainViewController(reactor: reactor)
    self.baseViewController = homeMainViewController
    self.pushViewController(viewController: homeMainViewController, animated: false)
  }
}

// MARK: - Handle Child Actions

extension SampleHomeCoordinatorImpl {
  /// handleChildEvent에서 Child의 케이스별로 부모가 처리할 동작 정의
}

// MARK: - Create and Start(Show) with Flow(View)

extension SampleHomeCoordinatorImpl {
  
  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  private func showProfile() {
    let profileUseCase = dependency.makeProfileUseCase()
    let reactor = ProfileReactor(
      coordinator: self,
      profileUseCase: profileUseCase
    )
    let profileVC = ProfileViewController(reactor: reactor)
    navigationController.pushViewController(profileVC, animated: true)
  }
  
  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  private func showSettings() {
    let settingUseCase = dependency.makeSettingUseCase()
    let reactor = SettingReactor(
      coordinator: self,
      settingUseCase: settingUseCase
    )
    let settingVC = SettingViewController(reactor: reactor)
    navigationController.pushViewController(settingVC, animated: true)
  }
}



// MARK: - SampleHome(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension SampleHomeCoordinatorImpl {
  func logout() {
    requireParentAction(.logout)
  }
}
