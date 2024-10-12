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
import FeedDependencyFactory
import ImageDependencyFactory
import RecordsDependencyFactory
import CommentDependencyFactory

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
import FeedDomain
import ImageDomain
import RecordsDomain

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
    feedDependencyFactory: FeedDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory,
    recordsDependencyFactory: RecordsDependencyFactory,
    commentDependencyFactory: CommentDependencyFactory
  ) -> any MyPageCoordinator {
    return MyPageCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      myPageDependencyFactory: self,
      fcmDependencyFactory: fcmDependencyFactory,
      authDependencyFactory: authDependencyFactory,
      membersDependencyFactory: membersDependencyFactory,
      FeedDependencyFactory: feedDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      recordsDependencyFactory: recordsDependencyFactory,
      commentDependencyFactory: commentDependencyFactory
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
    fetchMemberInfoUseCase: FetchMemberInfoUseCase,
    checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase,
    checkCalendarRecordsUseCase: CheckCalendarRecordsUseCase,
    memberProfileInfoUseCase: MemberInfoUseCase,
    memberId: Int? = nil,
    isFeedProfile: Bool
  ) -> any MyPageReactor {
    return MyPageReactorImp(
      coordinator: coordinator,
      fetchWalWalCalendarModelsUseCase: fetchWalWalCalendarModelsUseCase,
      fetchMemberInfoUseCase: fetchMemberInfoUseCase,
      checkCompletedTotalRecordsUseCase: checkCompletedTotalRecordsUseCase,
      checkCalendarRecordsUseCase: checkCalendarRecordsUseCase,
      memberProfileInfoUseCase: memberProfileInfoUseCase,
      memberId: memberId,
      isFeedProfile: isFeedProfile
    )
  }
  
  public func injectMyPageViewController<T: MyPageReactor>(
    reactor: T,
    memberId: Int? = nil,
    nickName: String? = nil,
    isOther: Bool = false
  ) -> any MyPageViewController {
    
    return MyPageViewControllerImp(
      reactor: reactor,
      memberId: memberId,
      nickname: nickName,
      isOther: isOther
    )
  }
  
  public func injectRecordDetailReactor<T: MyPageCoordinator>(
    coordinator: T,
    fetchUserFeedUseCase: FetchUserFeedUseCase,
    memberId: Int
  ) -> any RecordDetailReactor{
    return RecordDetailReactorImp(coordinator: coordinator, fetchUserFeedUseCase: fetchUserFeedUseCase, memberId: memberId)
  }
  
  public func injectRecordDetailViewController<T: RecordDetailReactor>(
    reactor: T,
    memberId: Int,
    memberNickname: String,
    recordId: Int
  ) -> any RecordDetailViewController {
    return RecordDetailViewControllerImp(
      reactor: reactor,
      nickname: memberNickname,
      memberId: memberId,
      recordId: recordId,
      isFeedRecord: false
    )
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
    uploadMemberUseCase: UploadMemberUseCase,
    memberInfoUseCase: MemberInfoUseCase
  ) -> any ProfileEditReactor {
    return ProfileEditReactorImp(
      coordinator: coordinator,
      editProfileUseCase: editProfileUseCase,
      checkNicknameUseCase: checkNicknameUseCase,
      fetchMemberInfoUseCase: fetchMemberInfoUseCase,
      uploadMemberUseCase: uploadMemberUseCase,
      memberInfoUseCase: memberInfoUseCase
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
  
  public func injectTermsReactor<T: MyPageCoordinator>(coordinator: T) -> any TermsReactor {
    return TermsReactorImp(coordinator: coordinator)
  }
  public func injectTermsViewController<T: TermsReactor>(
    reactor: T,
    type: TermsType
  ) -> any TermsViewController {
    return TermsViewControllerImp(
      reactor: reactor,
      termType: type
    )
  }
}
