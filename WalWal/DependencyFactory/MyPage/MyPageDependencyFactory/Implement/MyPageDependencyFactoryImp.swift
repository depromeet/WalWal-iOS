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
import FCMDomain

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
  
  public func injectTokenDeleteUseCase() -> TokenDeleteUseCase {
    return TokenDeleteUseCaseImp()
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
    fcmDeleteUseCase: FCMDeleteUseCase
  ) -> any ProfileSettingReactor {
    return ProfileSettingReactorImp(
      coordinator: coordinator,
      tokenDeleteUseCase: tokenDeleteUseCase,
      fcmDeleteUseCase: fcmDeleteUseCase
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
