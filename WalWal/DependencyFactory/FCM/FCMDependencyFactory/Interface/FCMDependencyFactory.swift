//
//  FCMDependencyFactoryInterface.swift
//
//  FCM
//
//  Created by Jiyeon
//

import UIKit

import BaseCoordinator

import FCMCoordinator
import FCMDomain
import FCMData
import FCMPresenter

public protocol FCMDependencyFactory {
  func injectFCMCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator
  ) -> any FCMCoordinator
  func injectFCMReactor<T: FCMCoordinator>(
    coordinator: T,
    fetchFCMListUseCase: FetchFCMListUseCase,
    fcmListUseCase: FCMListUseCase,
    readFCMItemUseCase: ReadFCMItemUseCase
  ) -> any FCMReactor
  func injectFCMViewController<T: FCMReactor>(reactor: T) -> any FCMViewController
  func injectFCMRepository() -> FCMRepository
  func injectFCMSaveUseCase() -> FCMSaveUseCase
  func injectFCMDeleteUseCase() -> FCMDeleteUseCase
  func injectFCMListUseCase() -> FCMListUseCase
  func injectSaveFCMListGlobalStateUseCase() -> SaveFCMListGlobalStateUseCase
  func injectFetchFCMListUseCase() -> FetchFCMListUseCase
  func injectReadFCMItemUseCase() -> ReadFCMItemUseCase
  func injectGlobalRemoveFCMListUseCase() -> RemoveGlobalFCMListUseCase
}
