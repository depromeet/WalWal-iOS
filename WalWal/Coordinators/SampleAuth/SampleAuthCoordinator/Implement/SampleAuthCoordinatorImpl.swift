//
//  SampleAuthCoordinatorImpl.swift
//
//  SampleAuth
//
//  Created by 조용인
//

import UIKit
import Utility
import DependencyFactory
import SampleAuthCoordinator

import RxSwift
import RxCocoa

public final class SampleAuthCoordinatorImpl: SampleAuthCoordinator {
  
  public typealias Action = SampleAuthCoordinatorAction
  public typealias Flow = SampleAuthCoordinatorFlow
  
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
        case .showSignIn:
          owner.showSignIn()
        case .showSignUp:
          owner.showSignUp()
        }
      })
      .disposed(by: disposeBag)
  }
  
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    /// 여기도, Auth가 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  }
  
  public func start() {
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

// MARK: - Handle Child Actions

extension SampleAuthCoordinatorImpl {
  /// handleChildEvent에서 Child의 케이스별로 부모가 처리할 동작 정의
}

// MARK: - Create and Start(Show) with Flow(View)

extension SampleAuthCoordinatorImpl {
  
  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  fileprivate func showSignIn() {
    let signInUsecase = dependency.makeSignInUseCase()
    let reactor = SignInReactor(
      coordinator: self,
      signInUsecase: signInUsecase
    )
    let signInVC = SignInViewController(reactor: reactor)
    navigationController.pushViewController(signInVC, animated: true)
  }
  
  /// 단순히, VC를 보여주는 로직이기 때문에, show를 prefix로 사용합니다.
  fileprivate func showSignUp() {
    let signUpUsecase = dependency.makeSignUpUseCase()
    let reactor = SignInReactor(
      coordinator: self,
      signUpUsecase: signUpUsecase
    )
    let signUpVC = SignUpViewController(reactor: reactor)
    navigationController.pushViewController(signUpVC, animated: true)
  }
}



// MARK: - SampleAuth(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension SampleAuthCoordinatorImpl {
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
