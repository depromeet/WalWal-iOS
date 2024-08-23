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
  func injectFCMReactor<T: FCMCoordinator>(coordinator: T) -> any FCMReactor
  func injectFCMViewController<T: FCMReactor>(reactor: T) -> any FCMViewController
  func injectFCMRepository() -> FCMRepository
  func injectFCMSaveUseCase() -> FCMSaveUseCase
  func injectFCMDeleteUseCase() -> FCMDeleteUseCase
}
