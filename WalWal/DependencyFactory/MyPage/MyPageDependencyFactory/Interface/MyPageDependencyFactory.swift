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
  func makeMyPageReactor<T: MyPageCoordinator>(coordinator: T) -> any MyPageReactor
  func makeMyPageViewController<T: MyPageReactor>(reactor: T) -> any MyPageViewController
  func makeRecordDetailReactor<T: MyPageCoordinator>(coordinator: T) -> any RecordDetailReactor
  func makeRecordDetailViewController<T: RecordDetailReactor>(reactor: T) -> any RecordDetailViewController
  func makeProfileEditReactor<T: MyPageCoordinator>(coordinator: T) -> any ProfileEditReactor
  func makeProfileEditViewController<T: ProfileEditReactor>(reactor: T) -> any ProfileEditViewController
  func makeProfileSettingReactor<T: MyPageCoordinator>(
    coordinator: T,
    tokenDeleteUseCase: TokenDeleteUseCase
  ) -> any ProfileSettingReactor
  func makeProfileSettingViewController<T: ProfileSettingReactor>(reactor: T) -> any ProfileSettingViewController
}
