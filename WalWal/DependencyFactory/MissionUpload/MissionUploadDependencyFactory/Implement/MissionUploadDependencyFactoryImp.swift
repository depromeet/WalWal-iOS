//
//  MissionUploadDependencyFactoryImplement.swift
//
//  MissionUpload
//
//  Created by 조용인
//


import UIKit

import MissionUploadDependencyFactory
import RecordsDependencyFactory
import ImageDependencyFactory

import BaseCoordinator
import MissionUploadCoordinator
import MissionUploadCoordinatorImp

import MissionUploadDomain
import MissionUploadDomainImp
import MissionUploadPresenter
import MissionUploadPresenterImp

import RecordsDomain
import ImageDomain

public class MissionUploadDependencyFactoryImp: MissionUploadDependencyFactory {
  
  public init() {
    
  }
  
  public func injectMissionUploadCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: (any BaseCoordinator)?,
    recordsDependencyFactory: RecordsDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory
  ) -> any MissionUploadCoordinator {
    return MissionUploadCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      missionUploadDependencyFactory: self,
      recordsDependencyFactory: recordsDependencyFactory,
      imageDependencyFactory: imageDependencyFactory
    )
  }
  
  
  public func injectCameraShootDuringTheMissionReactorReactor<T: MissionUploadCoordinator>(
    coordinator: T,
    saveRecordUseCase: SaveRecordUseCase,
    uploadRecordUseCase: UploadRecordUseCase
  ) -> any CameraShootDuringTheMissionReactor {
    return CameraShootDuringTheMissionReactorImp(
      coordinator: coordinator,
      saveRecordUseCase: saveRecordUseCase,
      uploadRecordUseCase: uploadRecordUseCase
    )
  }
  
  public func injectCameraShootDuringTheMissionViewController<T: CameraShootDuringTheMissionReactor>(
    reactor: T
  ) -> any CameraShootDuringTheMissionViewController {
    return CameraShootDuringTheMissionViewControllerImp(
      reactor: reactor
    )
  }
  
}
