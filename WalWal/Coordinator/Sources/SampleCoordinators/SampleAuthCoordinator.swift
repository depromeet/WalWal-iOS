//
//  AuthCoordinator.swift
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

/// Auth가 종료 된 이후에 Parent에게 요구 할 행동
enum SampleAuthCoordinatorAction: ParentAction {
  case authenticationCompleted
  case authenticationFailed(Error)
}

/// Auth 내부에서 동작하는 화면전환
enum SampleAuthCoordinatorFlow: CoordinatorFlow {
  case showSignIn
  case showSignUp
}

class SampleAuthCoordinator: CoordinatorType {
  
  typealias Action = SampleAuthCoordinatorAction
  typealias Flow = SampleAuthCoordinatorFlow
  
  let disposeBag = DisposeBag()
  let destination = PublishSubject<Flow>()
  let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  let navigationController: UINavigationController
  weak var parentCoordinator: (any CoordinatorType)?
  let dependency: DependencyFactory
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
        case .showSignIn:
          owner.showSignIn()
        case .showSignUp:
          owner.showSignUp()
        }
      })
      .disposed(by: disposeBag)
  }
  
  func handleChildEvent<T: ParentAction>(_ event: T) {
    /// 여기도, Auth가 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  }
  
  func start() {
    /// 이런 Reactor랑 ViewController가 있다 치고~
    /// 다만, 해당 ViewController가 이 Coordinator의 Base역할을 하기 때문에, 이 ViewController에 해당하는 Reactor에 Coordinator를 주입 합니다.
    let authUseCase = dependency.makeAuthUseCase()
    let reactor = AuthMainReactor(
      coordinator: self,
      authUsecase: authUseCase
    )
    let authMainViewController = AuthMainViewController(reactor: reactor)
    self.baseViewController = authMainViewController
    self.pushViewController(viewController: authMainViewController, animated: false)
  }
  
}

// MARK: - Create and Start(Show) with Flow(View)

extension SampleAuthCoordinator {
  
  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  private func showSignIn() {
    let signInUsecase = dependency.makeSignInUseCase()
    let reactor = SignInReactor(
      coordinator: self,
      signInUsecase: signInUsecase
    )
    let signInVC = SignInViewController(reactor: reactor)
    navigationController.pushViewController(signInVC, animated: true)
  }
  
  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  private func showSignUp() {
    let signUpUsecase = dependency.makeSignUpUseCase()
    let reactor = SignInReactor(
      coordinator: self,
      signUpUsecase: signUpUsecase
    )
    let signUpVC = SignUpViewController(reactor: reactor)
    navigationController.pushViewController(signUpVC, animated: true)
  }
}

// MARK: - Auth(자식)의 동작 결과, App(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension SampleAuthCoordinator {
  func signInSuccessful() {
    requireParentAction(.authenticationCompleted)
  }
  
  func signUpSuccessful() {
    requireParentAction(.authenticationCompleted)
  }
  
  func authenticationFailed(error: Error) {
    /// 이렇게 부모에게 Authentication의 실패에 대한 동작 책임을 넘길 수 도 있고, 그냥 현재 Coordinator(Auth)에서 얼럿만 띄우는 형식으로 끝날 수 있고,,,
    requireParentAction(.authenticationFailed(error))
  }
}
