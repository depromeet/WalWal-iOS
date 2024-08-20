//
//  MissionDependencyFactoryImplement.swift
//
//  Mission
//
//  Created by 이지희
//

import UIKit
import MissionDependencyFactory
import MissionUploadDependencyFactory
import RecordsDependencyFactory

import WalWalNetwork

import BaseCoordinator
import MissionCoordinator
import MissionCoordinatorImp

import MissionData
import MissionDataImp
import MissionDomain
import MissionDomainImp
import MissionPresenter
import MissionPresenterImp

import RecordsDomain

public class MissionDependencyFactoryImp: MissionDependencyFactory {
  
  public init() {
    
  }
  
  public func injectMissionRepository() -> MissionRepository {
    let networkService = NetworkService()
    return MissionRepositoryImp(networkService: networkService)
  }
  
  
  public func injectTodayMissionUseCase() -> any TodayMissionUseCase {
    return TodayMissionUseCaseImp(missionDataRepository: injectMissionRepository())
  }
  
  public func injectMissionCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    missionUploadDependencyFactory: MissionUploadDependencyFactory,
    recordDependencyFactory: RecordsDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory
  ) -> any MissionCoordinator {
    return MissionCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      missionDependencyFactory: self,
      missionUploadDependencyFactory: missionUploadDependencyFactory,
      recordDependencyFactory: recordDependencyFactory,
      imageDependencyFactory: imageDependencyFactory
    )
  }
  
  public func injectMissionReactor<T>(
    coordinator: T,
    todayMissionUseCase: TodayMissionUseCase,
    checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase,
    checkRecordStatusUseCase: CheckRecordStatusUseCase,
    startRecordUseCase: StartRecordUseCase
  ) -> any MissionReactor where T : MissionCoordinator {
    return MissionReactorImp(
      coordinator: coordinator,
      todayMissionUseCase: todayMissionUseCase,
      checkCompletedTotalRecordsUseCase: checkCompletedTotalRecordsUseCase,
      checkRecordStatusUseCase: checkRecordStatusUseCase,
      startRecordUseCase: startRecordUseCase
    )
  }
  
  public func injectMissionViewController<T: MissionReactor>(reactor: T) -> any MissionViewController {
    return MissionViewControllerImp(reactor: reactor)
  }
}
