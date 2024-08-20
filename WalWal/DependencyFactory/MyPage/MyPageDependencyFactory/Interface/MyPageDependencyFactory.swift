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


public protocol MyPageDependencyFactory {
  
  func makeMyPageCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory,
    authDependencyFactory: AuthDependencyFactory,
    membersDependencyFactory: MembersDependencyFactory
  ) -> any MyPageCoordinator
  func injectMyPageRepository() -> MyPageRepository
  func injectFetchWalWalCalendarModelsUseCase() -> FetchWalWalCalendarModelsUseCase
  
  func injectMyPageReactor<T: MyPageCoordinator>(
    coordinator: T,
    fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase
  ) -> any MyPageReactor
  func injectMyPageViewController<T: MyPageReactor>(reactor: T) -> any MyPageViewController
  func injectRecordDetailReactor<T: MyPageCoordinator>(coordinator: T) -> any RecordDetailReactor
  func injectRecordDetailViewController<T: RecordDetailReactor>(reactor: T) -> any RecordDetailViewController
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
