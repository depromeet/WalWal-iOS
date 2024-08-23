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

import ImageDependencyFactory
import ImageDomain

public protocol MyPageDependencyFactory {
  
  func makeMyPageCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory
  ) -> any MyPageCoordinator
  func injectMyPageRepository() -> MyPageRepository
  func injectFetchWalWalCalendarModelsUseCase() -> FetchWalWalCalendarModelsUseCase
  
  // MARK: - MyPage
  
  func injectMyPageReactor<T: MyPageCoordinator>(
    coordinator: T,
    fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase
  ) -> any MyPageReactor
  func injectMyPageViewController<T: MyPageReactor>(reactor: T) -> any MyPageViewController
  
  // MARK: - RecordDetail
  
  func injectRecordDetailReactor<T: MyPageCoordinator>(coordinator: T) -> any RecordDetailReactor
  func injectRecordDetailViewController<T: RecordDetailReactor>(reactor: T) -> any RecordDetailViewController
  
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
}
