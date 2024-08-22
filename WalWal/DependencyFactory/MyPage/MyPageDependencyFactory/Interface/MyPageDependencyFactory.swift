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


public protocol MyPageDependencyFactory {
  
  func makeMyPageCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory,
    feedDependencyFactory: FeedDependencyFactory
  ) -> any MyPageCoordinator
  
  func injectMyPageRepository() -> MyPageRepository
  func injectFetchWalWalCalendarModelsUseCase() -> FetchWalWalCalendarModelsUseCase
  
  func injectMyPageReactor<T: MyPageCoordinator>(
    coordinator: T,
    fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase
  ) -> any MyPageReactor
  func injectMyPageViewController<T: MyPageReactor>(reactor: T) -> any MyPageViewController
  
  func injectRecordDetailReactor<T: MyPageCoordinator>(
    coordinator: T,
    fetchUserFeedUseCase: FetchUserFeedUseCase
  ) -> any RecordDetailReactor
  func injectRecordDetailViewController<T: RecordDetailReactor>(
    reactor: T,
    memberId: Int,
    memberNickname: String
  ) -> any RecordDetailViewController
  
  func injectProfileEditReactor<T: MyPageCoordinator>(coordinator: T) -> any ProfileEditReactor
  func injectProfileEditViewController<T: ProfileEditReactor>(reactor: T) -> any ProfileEditViewController
  
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
