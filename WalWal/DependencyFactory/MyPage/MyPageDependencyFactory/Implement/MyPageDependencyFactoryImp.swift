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
import AuthDependencyFactory
import MembersDependencyFactory
import ImageDependencyFactory

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
import AuthDomain
import MembersDomain
import ImageDomain

import WalWalNetwork

public class MyPageDependencyFactoryImp: MyPageDependencyFactory {
  
  public init() {
    
  }
  
  public func makeMyPageCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: any AuthDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory
  ) -> any MyPageCoordinator {
    return MyPageCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      myPageDependencyFactory: self,
      fcmDependencyFactory: fcmDependencyFactory,
      authDependencyFactory: authDependencyFactory,
      membersDependencyFactory: membersDependencyFactory,
      imageDependencyFactory: imageDependencyFactory
    )
  }
  
  public func injectMyPageRepository() -> MyPageRepository {
    let networkService = NetworkService()
    return MyPageRepositoryImp(networkService: networkService)
  }
  
  public func injectFetchWalWalCalendarModelsUseCase() -> FetchWalWalCalendarModelsUseCase {
    return FetchWalWalCalendarModelsUseCaseImp()
  }
  
  public func injectMyPageReactor<T: MyPageCoordinator>(
    coordinator: T,
    fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase
  ) -> any MyPageReactor {
    return MyPageReactorImp(
      coordinator: coordinator,
      fetchWalWalCalendarModelsUseCase: fetchWalWalCalendarModelsUseCase,
      fetchMemberInfoUseCase: fetchMemberInfoUseCase
    )
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
    kakaoLogoutUseCase: KakaoLogoutUseCase,
    kakaoUnlinkUseCase: KakaoUnlinkUseCase
  ) -> any ProfileSettingReactor {
    return ProfileSettingReactorImp(
      coordinator: coordinator,
      tokenDeleteUseCase: tokenDeleteUseCase,
      fcmDeleteUseCase: fcmDeleteUseCase,
      withdrawUseCase: withdrawUseCase,
      kakaoLogoutUseCase: kakaoLogoutUseCase,
      kakaoUnlinkUseCase: kakaoUnlinkUseCase
    )
  }
  
  public func injectProfileSettingViewController<T: ProfileSettingReactor>(reactor: T) -> any ProfileSettingViewController {
    return ProfileSettingViewControllerImp(reactor: reactor)
  }
  
  public func injectProfileEditReactor<T: MyPageCoordinator>(
    coordinator: T,
    editProfileUseCase: EditProfileUseCase,
    checkNicknameUseCase: CheckNicknameUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase,
    uploadMemberUseCase: UploadMemberUseCase
  ) -> any ProfileEditReactor {
    return ProfileEditReactorImp(
      coordinator: coordinator,
      editProfileUseCase: editProfileUseCase,
      checkNicknameUseCase: checkNicknameUseCase,
      fetchMemberInfoUseCase: fetchMemberInfoUseCase,
      uploadMemberUseCase: uploadMemberUseCase
    )
  }
  
  public func injectProfileEditViewController<T: ProfileEditReactor>(
    reactor: T,
    nickname: String,
    defaultProfile: String?,
    selectImage: UIImage?,
    raisePet: String
  ) -> any ProfileEditViewController {
    return ProfileEditViewControllerImp(
      reactor: reactor,
      nickname: nickname,
      defaultProfile: defaultProfile,
      selectImage: selectImage,
      raisePet: raisePet
    )
  }
}
