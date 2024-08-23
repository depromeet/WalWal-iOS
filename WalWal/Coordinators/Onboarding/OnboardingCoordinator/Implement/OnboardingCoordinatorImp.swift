//
//  OnboardingCoordinatorImp.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import UIKit
import OnboardingDependencyFactory
import FCMDependencyFactory
import ImageDependencyFactory
import AuthDependencyFactory
import MembersDependencyFactory

import BaseCoordinator
import OnboardingCoordinator

import RxSwift
import RxCocoa

public final class OnboardingCoordinatorImp: OnboardingCoordinator {
  
  public typealias Action = OnboardingCoordinatorAction
  public typealias Flow = OnboardingCoordinatorFlow
  
  public let disposeBag = DisposeBag()
  public let destination = PublishRelay<Flow>()
  public let requireFromChild = PublishSubject<CoordinatorEvent<Action>>()
  public let navigationController: UINavigationController
  public weak var parentCoordinator: (any BaseCoordinator)?
  public var childCoordinator: (any BaseCoordinator)?
  public var baseViewController: UIViewController?
  
  public var onboardingDependencyFactory: OnboardingDependencyFactory
  private var fcmDependencyFactory: FCMDependencyFactory
  private var imageDependencyFactory: ImageDependencyFactory
  private var authDependencyFactory: AuthDependencyFactory
  private var membersDependencyFactory: MembersDependencyFactory
  
  public required init(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    onboardingDependencyFactory: OnboardingDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory,
    imageDependecyFactory: ImageDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory
  ) {
    self.navigationController = navigationController
    self.parentCoordinator = parentCoordinator
    self.onboardingDependencyFactory = onboardingDependencyFactory
    self.fcmDependencyFactory = fcmDependencyFactory
    self.imageDependencyFactory = imageDependecyFactory
    self.authDependencyFactory = authDependencyFactory
    self.membersDependencyFactory = membersDependencyFactory
    bindChildToParentAction()
    bindState()
  }
  
  public func bindState() {
    destination
      .subscribe(with: self, onNext: { owner, flow in
        switch flow { 
        case .showSelect:
          owner.showOnboardingSelect()
        case let .showProfile(petType):
          owner.showOnboardingProfile(petType)
        }
      })
      .disposed(by: disposeBag)
  }
  
  /// 자식 Coordinator들로부터 전달된 Action을 근거로, 이후 동작을 정의합니다.
  /// 여기도, Onboarding이 부모로써 Child로부터 받은 event가 있다면 처리해주면 됨.
  public func handleChildEvent<T: ParentAction>(_ event: T) {
//    if let __Event = event as? CoordinatorEvent<__CoordinatorAction> {
//      handle__Event(__Event)
//    } else if let __Event = event as? CoordinatorEvent<__CoordinatorAction> {
//      handle__Event(__Event)
//    }
  }
  
  public func start() {
    let reactor = onboardingDependencyFactory.injectOnboardingReactor(coordinator: self)
    let vc = onboardingDependencyFactory.injectOnboardingViewController(reactor: reactor)
    self.baseViewController = vc
    self.pushViewController(viewController: vc, animated: false)
  }
}

// MARK: - Handle Child Actions

extension OnboardingCoordinatorImp {
  
}

// MARK: - Create and Start(Show) with Flow(View)

extension OnboardingCoordinatorImp {
  func showOnboardingSelect() {
    let reactor = onboardingDependencyFactory.injectOnboardingSelectReactor(coordinator: self)
    let vc = onboardingDependencyFactory.injectOnboardingSelectViewController(reactor: reactor)
    self.pushViewController(viewController: vc, animated: true)
  }
  
  func showOnboardingProfile(_ petType: String) {
    
    let fcmSaveUseCase = fcmDependencyFactory.injectFCMSaveUseCase()
    let uploadMemberUseCase = imageDependencyFactory.injectUploadMemberUseCase()
    let registerUseCase = authDependencyFactory.injectRegisterUseCase()
    let userTokensUseCase = authDependencyFactory.injectUserTokensUseCase()
    let memberInfoUseCase = membersDependencyFactory.injectMemberInfoUseCase()
    let checkNicknameUseCase = membersDependencyFactory.injectCheckNicknameUseCase()
    let reactor = onboardingDependencyFactory.injectOnboardingProfileReactor(
      coordinator: self,
      fcmSaveUseCase: fcmSaveUseCase,
      uploadMemberUseCase: uploadMemberUseCase,
      registerUseCase: registerUseCase,
      userTokensUseCase: userTokensUseCase,
      memberInfoUseCase: memberInfoUseCase,
      checkNicknameUseCase: checkNicknameUseCase
    )
    let vc = onboardingDependencyFactory.injectOnboardingProfileViewController(reactor: reactor, petType: petType)
    self.pushViewController(viewController: vc, animated: true)
  }
}



// MARK: - Onboarding(자식)의 동작 결과, __(부모)에게 특정 Action을 요청합니다. 실제 사용은 reactor에서 호출

extension OnboardingCoordinatorImp {
  public func startMission() {
    requireParentAction(.startMission)
  }
}
