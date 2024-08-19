//
//  AuthDependencyFactoryImplement.swift
//
//  Auth
//
//  Created by 조용인
//

import UIKit
import AuthDependencyFactory
import FCMDependencyFactory
import RecordsDependencyFactory
import MembersDependencyFactory

import WalWalNetwork

import BaseCoordinator
import AuthCoordinator
import AuthCoordinatorImp

import AuthData
import AuthDataImp
import AuthDomain
import AuthDomainImp
import AuthPresenter
import AuthPresenterImp

import FCMDomain
import RecordsDomain
import MembersDomain

public class AuthDependencyFactoryImp: AuthDependencyFactory {
  
  public init() { }
  
  public func injectAuthCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator,
    fcmDependencyFactory: FCMDependencyFactory,
    recordsDependencyFactory: RecordsDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory
  ) -> any AuthCoordinator {
    return AuthCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      authDependencyFactory: self,
      fcmDependencyFactory: fcmDependencyFactory,
      recordsDependencyFactory: recordsDependencyFactory,
      membersDependencyFactory: membersDependencyFactory
    )
  }
  
  public func injectAuthRepository() -> AuthRepository {
    let networkService = NetworkService()
    return AuthRepositoryImp(networkService: networkService)
  }
  
  public func injectSocialLoginUseCase() -> SocialLoginUseCase {
    return SocialLoginUseCaseImp(authDataRepository: injectAuthRepository())
  }
  
  public func injectRegisterUseCase() -> RegisterUseCase {
    return RegisterUseCaseImp(authRepository: injectAuthRepository())
  }
  
  public func injectUserTokensUseCase() -> UserTokensSaveUseCase {
    return UserTokensSaveUseCaseImp()
  }
  
  public func injectKakaoLogoutUseCase() -> KakaoLogoutUseCase {
    return KakaoLogoutUseCaseImp()
  }
  
  public func injectTokenDeleteUseCase() -> TokenDeleteUseCase {
    return TokenDeleteUseCaseImp()
  }
  
  public func injectKakaoLoginUseCase() -> KakaoLoginUseCase {
    return KakaoLoginUseCaseImp()
  }
  
  public func injectWithdrawUseCase() -> WithdrawUseCase {
    return WithdrawUseCaseImp(authRepository: injectAuthRepository())
  }
  
  public func injectKakaoUnlinkUseCase() -> KakaoUnlinkUseCase {
    return KakaoUnlinkUseCaseImp()
  }
  public func injectAuthReactor<T: AuthCoordinator>(
    coordinator: T,
    socialLoginUseCase: SocialLoginUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    userTokensSaveUseCase: UserTokensSaveUseCase,
    kakaoLoginUseCase: KakaoLoginUseCase,
    checkRecordCalendarUseCase: CheckCalendarRecordsUseCase,
    removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase,
    memberInfoUseCase: MemberInfoUseCase
  ) -> any AuthReactor {
    return AuthReactorImp(
      coordinator: coordinator,
      socialLoginUseCase: socialLoginUseCase,
      fcmSaveUseCase: fcmSaveUseCase,
      userTokensSaveUseCase: userTokensSaveUseCase,
      kakaoLoginUseCase: kakaoLoginUseCase,
      checkRecordCalendarUseCase: checkRecordCalendarUseCase,
      removeGlobalCalendarRecordsUseCase: removeGlobalCalendarRecordsUseCase,
      memberInfoUseCase: memberInfoUseCase
    )
  }
  
  public func injectAuthViewController<T: AuthReactor>(reactor: T) -> any AuthViewController {
    return AuthViewControllerImp(reactor: reactor)
  }
  
}
