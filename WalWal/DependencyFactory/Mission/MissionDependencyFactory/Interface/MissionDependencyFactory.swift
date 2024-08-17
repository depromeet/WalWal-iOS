//
//  MissionDependencyFactoryInterface.swift
//
//  Mission
//
//  Created by 이지희
//

import UIKit
import BaseCoordinator
import MissionCoordinator

import MissionData
import MissionDomain
import MissionPresenter

public protocol MissionDependencyFactory {
  
  func injectMissionRepository() -> MissionRepository
  func injectTodayMissionUseCase() -> TodayMissionUseCase
  func injectMissionCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?
  ) -> any MissionCoordinator
  func injectMissionReactor<T: MissionCoordinator>(coordinator: T, todayMissionUseCase: any TodayMissionUseCase) -> any MissionReactor
  func injectMissionViewController<T: MissionReactor>(reactor: T) -> any MissionViewController
}
