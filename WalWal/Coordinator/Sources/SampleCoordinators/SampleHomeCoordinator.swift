//
//  HomeCoordinator.swift
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

enum SampleHomeCoordinatorAction: ParentAction {
  case logout
}

enum SampleHomeCoordinatorFlow: CoordinatorFlow {
  case showProfile
  case showSettings
}

class SampleHomeCoordinator: CoordinatorType {
  
  typealias Action = SampleHomeCoordinatorAction
  typealias Flow = SampleHomeCoordinatorFlow
  
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
    self.parentCoordinator = parentCoordinator
    self.dependency = dependency
    bindChildToParentAction()
    bindState()
  }
  
  func bindState() {
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
  
  func handleChildEvent<T: ParentAction>(_ event: T) {
    /// 여기도, Home이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  }
  
  func start() {
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

// MARK: - Create and Start(Show) with Flow(View)

extension SampleHomeCoordinator {
  
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

// MARK: - Home(자식)의 동작 결과, App(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension SampleHomeCoordinator {
  func logout() {
    requireParentAction(.logout)
  }
}
