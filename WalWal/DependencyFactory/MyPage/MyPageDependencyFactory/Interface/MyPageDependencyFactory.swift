//
//  MyPageDependencyFactoryInterface.swift
//
//  MyPage
//
//  Created by 조용인
//

import UIKit
import BaseCoordinator
import MyPageCoordinator

import MyPageData
import MyPageDomain
import MyPagePresenter

import FCMDependencyFactory
import FCMDomain

import AuthDependencyFactory
import AuthDomain

import MembersDependencyFactory
import MembersDomain

import FeedDependencyFactory
import FeedDomain

import ImageDependencyFactory
import ImageDomain

import RecordsDependencyFactory
import RecordsDomain

import CommentDependencyFactory

public protocol MyPageDependencyFactory {
  
  func makeMyPageCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory,
    recordsDependencyFactory: RecordsDependencyFactory,
    commentDependencyFactory: CommentDependencyFactory
  ) -> any MyPageCoordinator
  
  func injectMyPageRepository() -> MyPageRepository
  func injectFetchWalWalCalendarModelsUseCase() -> FetchWalWalCalendarModelsUseCase
  
  // MARK: - MyPage
  
  func injectMyPageReactor<T: MyPageCoordinator>(
    coordinator: T,
    fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase,
    checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase,
    checkCalendarRecordsUseCase: CheckCalendarRecordsUseCase,
    memberProfileInfoUseCase: MemberInfoUseCase,
    memberId: Int?,
    isFeedProfile: Bool
  ) -> any MyPageReactor
  func injectMyPageViewController<T: MyPageReactor>(
    reactor: T,
    memberId: Int?,
    nickName: String?,
    isOther: Bool
  ) -> any MyPageViewController
  

  // MARK: - RecordDetail
  
  func injectRecordDetailReactor<T: MyPageCoordinator>(
    coordinator: T,
    fetchUserFeedUseCase: FetchUserFeedUseCase,
    memberId: Int
  ) -> any RecordDetailReactor
  func injectRecordDetailViewController<T: RecordDetailReactor>(
    reactor: T,
    memberId: Int,
    memberNickname: String,
    recordId: Int
  ) -> any RecordDetailViewController
  
  // MARK: - ProfileEdit
  
  func injectProfileEditReactor<T: MyPageCoordinator>(
    coordinator: T,
    editProfileUseCase: EditProfileUseCase,
    checkNicknameUseCase: CheckNicknameUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase,
    uploadMemberUseCase: UploadMemberUseCase,
    memberInfoUseCase: MemberInfoUseCase
  ) -> any ProfileEditReactor
  func injectProfileEditViewController<T: ProfileEditReactor>(
    reactor: T,
    nickname: String,
    defaultProfile: String?,
    selectImage: UIImage?,
    raisePet: String
  ) -> any ProfileEditViewController
  
  // MARK: - ProfileSetting
  
  func injectProfileSettingReactor<T: MyPageCoordinator>(
    coordinator: T,
    tokenDeleteUseCase: TokenDeleteUseCase,
    fcmDeleteUseCase: FCMDeleteUseCase,
    withdrawUseCase: WithdrawUseCase,
    kakaoLogoutUseCase: KakaoLogoutUseCase,
    kakaoUnlinkUseCase: KakaoUnlinkUseCase
  ) -> any ProfileSettingReactor
  func injectProfileSettingViewController<T: ProfileSettingReactor>(reactor: T) -> any ProfileSettingViewController
  
  func injectTermsReactor<T: MyPageCoordinator>(coordinator: T) -> any TermsReactor
  func injectTermsViewController<T: TermsReactor>(
    reactor: T,
    type: TermsType
  ) -> any TermsViewController
}
