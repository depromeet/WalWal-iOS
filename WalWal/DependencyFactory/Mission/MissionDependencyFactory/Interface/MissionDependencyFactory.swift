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

import RecordsDependencyFactory

import MissionData
import MissionDomain
import MissionPresenter

import RecordsDomain

public protocol MissionDependencyFactory {
  
  func injectMissionRepository() -> MissionRepository
  func injectTodayMissionUseCase() -> TodayMissionUseCase
  func injectMissionCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    recordDependencyFactory: RecordsDependencyFactory
  ) -> any MissionCoordinator
  func injectMissionReactor<T: MissionCoordinator>(
    coordinator: T,
    todayMissionUseCase: TodayMissionUseCase,
    checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase,
    checkRecordStatusUseCase: CheckRecordStatusUseCase,
    startRecordUseCase: StartRecordUseCase
  ) -> any MissionReactor
  func injectMissionViewController<T: MissionReactor>(reactor: T) -> any MissionViewController
}
