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
import ImageDependencyFactory
import FCMDependencyFactory

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
import FCMDomain

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
    imageDependencyFactory: ImageDependencyFactory,
    fcmDependencyFactory: FCMDependencyFactory
  ) -> any MissionCoordinator {
    return MissionCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      missionDependencyFactory: self,
      missionUploadDependencyFactory: missionUploadDependencyFactory,
      recordDependencyFactory: recordDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      fcmDependencyFactory: fcmDependencyFactory
    )
  }
  
  public func injectMissionReactor<T>(
    coordinator: T,
    todayMissionUseCase: TodayMissionUseCase,
    checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase,
    checkRecordStatusUseCase: CheckRecordStatusUseCase,
    checkRecordCalendarUseCase: CheckCalendarRecordsUseCase,
    removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase,
    startRecordUseCase: StartRecordUseCase,
    removeGlobalFCMListUseCase: RemoveGlobalFCMListUseCase
  ) -> any MissionReactor where T : MissionCoordinator {
    return MissionReactorImp(
      coordinator: coordinator,
      todayMissionUseCase: todayMissionUseCase,
      checkCompletedTotalRecordsUseCase: checkCompletedTotalRecordsUseCase,
      checkRecordStatusUseCase: checkRecordStatusUseCase,
      checkRecordCalendarUseCase: checkRecordCalendarUseCase,
      removeGlobalCalendarRecordsUseCase: removeGlobalCalendarRecordsUseCase,
      startRecordUseCase: startRecordUseCase,
      removeGlobalFCMListUseCase: removeGlobalFCMListUseCase
    )
  }
  
  public func injectMissionViewController<T: MissionReactor>(reactor: T) -> any MissionViewController {
    return MissionViewControllerImp(reactor: reactor)
  }
  
  public func injectMissionSelectReactor<T: MissionCoordinator>(
    coordinator: T,
    recordId: Int,
    missionId: Int
  ) -> any MissionSelectReactor {
    return MissionSelectReactorImp(
      coordinator: coordinator,
      missionId: missionId,
      recordId: recordId
    )
  }
  
  public func injectMissionSelectViewController<T: MissionSelectReactor>(reactor: T) -> any MissionSelectViewController {
    return MissionSelectViewControllerImp(reactor: reactor)
  }
  
}
