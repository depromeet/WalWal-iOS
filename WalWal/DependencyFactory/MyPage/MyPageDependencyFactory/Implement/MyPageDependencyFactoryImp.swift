//
//  MyPageDependencyFactoryImplement.swift
//
//  MyPage
//
//  Created by 조용인
//

import UIKit
import MyPageDependencyFactory
import FCMDependencyFactory

import BaseCoordinator
import MyPageCoordinator
import MyPageCoordinatorImp

import MyPagePresenter
import MyPagePresenterImp
import MyPageDomain
import MyPageDomainImp
import MyPageData
import MyPageDataImp
import FCMDomain

import WalWalNetwork

public class MyPageDependencyFactoryImp: MyPageDependencyFactory {
  
  public init() {
    
  }
  
  public func makeMyPageCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory
  ) -> any MyPageCoordinator {
    return MyPageCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      myPageDependencyFactory: self,
      fcmDependencyFactory: fcmDependencyFactory
    )
  }
  
  public func injectMyPageRepository() -> MyPageRepository {
    let networkService = NetworkService()
    return MyPageRepositoryImp(networkService: networkService)
  }
  
  public func injectTokenDeleteUseCase() -> TokenDeleteUseCase {
    return TokenDeleteUseCaseImp()
  }
  
  public func injectWithdrawUseCase() -> WithdrawUseCase {
    return WithdrawUseCaseImp(mypageRepository: injectMyPageRepository())
  }
  
  public func injectLogoutUseCase() -> LogoutUseCase {
    return LogoutUseCaseImp()
  }
  
  public func injectMyPageReactor<T: MyPageCoordinator>(coordinator: T) -> any MyPageReactor {
    return MyPageReactorImp(coordinator: coordinator)
  }
  
  public func injectMyPageViewController<T: MyPageReactor>(reactor: T) -> any MyPageViewController {
    return MyPageViewControllerImp(reactor: reactor)
  }
  
  public func injectRecordDetailReactor<T: MyPageCoordinator>(coordinator: T) -> any RecordDetailReactor {
    return RecordDetailReactorImp(coordinator: coordinator)
  }
  
  public func injectRecordDetailViewController<T: RecordDetailReactor>(reactor: T) -> any RecordDetailViewController {
    return RecordDetailViewControllerImp(reactor: reactor)
  }
  
  public func injectProfileSettingReactor<T: MyPageCoordinator>(
    coordinator: T,
    tokenDeleteUseCase: TokenDeleteUseCase,
    fcmDeleteUseCase: FCMDeleteUseCase,
    withdrawUseCase: WithdrawUseCase,
    logoutUseCase: LogoutUseCase
  ) -> any ProfileSettingReactor {
    return ProfileSettingReactorImp(
      coordinator: coordinator,
      tokenDeleteUseCase: tokenDeleteUseCase,
      fcmDeleteUseCase: fcmDeleteUseCase,
      withdrawUseCase: withdrawUseCase,
      logoutUseCase: logoutUseCase
    )
  }
  
  public func injectProfileSettingViewController<T: ProfileSettingReactor>(reactor: T) -> any ProfileSettingViewController {
    return ProfileSettingViewControllerImp(reactor: reactor)
  }
  
  public func injectProfileEditReactor<T: MyPageCoordinator>(coordinator: T) -> any ProfileEditReactor {
    return ProfileEditReactorImp(coordinator: coordinator)
  }
  
  public func injectProfileEditViewController<T: ProfileEditReactor>(reactor: T) -> any ProfileEditViewController {
    return ProfileEditViewControllerImp(reactor: reactor)
  }
}
