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

public protocol MyPageDependencyFactory {
  
  func makeMyPageCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    fcmDependencyFactory: FCMDependencyFactory
  ) -> any MyPageCoordinator
  
  func injectMyPageRepository() -> MyPageRepository
  func injectTokenDeleteUseCase() -> TokenDeleteUseCase
  func injectWithdrawUseCase() -> WithdrawUseCase
  func injectMyPageReactor<T: MyPageCoordinator>(coordinator: T) -> any MyPageReactor
  func injectMyPageViewController<T: MyPageReactor>(reactor: T) -> any MyPageViewController
  func injectRecordDetailReactor<T: MyPageCoordinator>(coordinator: T) -> any RecordDetailReactor
  func injectRecordDetailViewController<T: RecordDetailReactor>(reactor: T) -> any RecordDetailViewController
  func injectProfileEditReactor<T: MyPageCoordinator>(coordinator: T) -> any ProfileEditReactor
  func injectProfileEditViewController<T: ProfileEditReactor>(reactor: T) -> any ProfileEditViewController
  func injectProfileSettingReactor<T: MyPageCoordinator>(
    coordinator: T,
    tokenDeleteUseCase: TokenDeleteUseCase,
    fcmDeleteUseCase: FCMDeleteUseCase,
    withdrawUseCase: WithdrawUseCase
  ) -> any ProfileSettingReactor
  func injectProfileSettingViewController<T: ProfileSettingReactor>(reactor: T) -> any ProfileSettingViewController
}
