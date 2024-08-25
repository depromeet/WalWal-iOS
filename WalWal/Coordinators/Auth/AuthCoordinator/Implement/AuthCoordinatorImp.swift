//
//  AuthCoordinatorImp.swift
//
//  Auth
//
//  Created by Jiyeon
//

import UIKit
import AuthDependencyFactory
import FCMDependencyFactory
import RecordsDependencyFactory
import MembersDependencyFactory
import BaseCoordinator
import AuthCoordinator

import RxSwift
import RxCocoa

public final class AuthCoordinatorImp: AuthCoordinator {
  
  public typealias Action = AuthCoordinatorAction
  public typealias Flow = AuthCoordinatorFlow
  
  public let disposeBag = DisposeBag()
  public let destination = PublishRelay<Flow>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  
  private let authDependencyFactory: AuthDependencyFactory
  private let fcmDependencyFactory: FCMDependencyFactory
  private let membersDependencyFactory: MembersDependencyFactory
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    authDependencyFactory: AuthDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.authDependencyFactory = authDependencyFactory
    self.fcmDependencyFactory = fcmDependencyFactory
    self.membersDependencyFactory = membersDependencyFactory
    bindChildToParentAction()
    bindState()
  }
  
  public func bindState() {
    
  }
  
  public func handleChildEvent<T: ParentAction>(_ event: T) {
    
  }
  
  public func start() {
    
    let socialLoginUseCase = authDependencyFactory.injectSocialLoginUseCase()
    let fcmSaveUseCase = fcmDependencyFactory.injectFCMSaveUseCase()
    let userTokensSaveUseCase = authDependencyFactory.injectUserTokensUseCase()
    let kakaoLoginUseCase = authDependencyFactory.injectKakaoLoginUseCase()
    let memberInfoUseCase = membersDependencyFactory.injectMemberInfoUseCase()
    
    let reactor = authDependencyFactory.injectAuthReactor(
      coordinator: self,
      socialLoginUseCase: socialLoginUseCase,
      fcmSaveUseCase: fcmSaveUseCase,
      userTokensSaveUseCase: userTokensSaveUseCase,
      kakaoLoginUseCase: kakaoLoginUseCase,
      memberInfoUseCase: memberInfoUseCase
    )
    let authVC = authDependencyFactory.injectAuthViewController(reactor: reactor)
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
  public func startOnboarding() {
    requireParentAction(.startOnboarding)
  }
  public func startMission() {
    requireParentAction(.startMission)
  }
}
