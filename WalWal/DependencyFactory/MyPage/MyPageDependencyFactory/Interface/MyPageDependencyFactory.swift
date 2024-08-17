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

public protocol MyPageDependencyFactory {
  
  func makeMyPageCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?
  ) -> any MyPageCoordinator
  func injectTokenDeleteUseCase() -> TokenDeleteUseCase
  func injectFetchWalWalCalendarModelsUseCase() -> FetchWalWalCalendarModelsUseCase
  func injectMyPageReactor<T: MyPageCoordinator>(
    coordinator: T,
    fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase
  ) -> any MyPageReactor
  func injectMyPageViewController<T: MyPageReactor>(reactor: T) -> any MyPageViewController
  func injectRecordDetailReactor<T: MyPageCoordinator>(coordinator: T) -> any RecordDetailReactor
  func injectRecordDetailViewController<T: RecordDetailReactor>(reactor: T) -> any RecordDetailViewController
  func injectProfileEditReactor<T: MyPageCoordinator>(coordinator: T) -> any ProfileEditReactor
  func injectProfileEditViewController<T: ProfileEditReactor>(reactor: T) -> any ProfileEditViewController
  func injectProfileSettingReactor<T: MyPageCoordinator>(
    coordinator: T,
    tokenDeleteUseCase: TokenDeleteUseCase
  ) -> any ProfileSettingReactor
  func injectProfileSettingViewController<T: ProfileSettingReactor>(reactor: T) -> any ProfileSettingViewController
}
