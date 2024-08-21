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
    imageDependencyFactory: ImageDependencyFactory,
    recordId: Int
  ) -> any MissionUploadCoordinator {
    return MissionUploadCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      missionUploadDependencyFactory: self,
      recordsDependencyFactory: recordsDependencyFactory,
      imageDependencyFactory: imageDependencyFactory,
      recordId: recordId
    )
  }
  
  public func injectCameraShootDuringTheMissionReactorReactor<T: MissionUploadCoordinator>(
    coordinator: T
  ) -> any CameraShootDuringTheMissionReactor {
    return CameraShootDuringTheMissionReactorImp(
      coordinator: coordinator
    )
  }
  
  public func injectWriteContentDuringTheMissionReactor<T: MissionUploadCoordinator>(
    coordinator: T,
    saveRecordUseCase: SaveRecordUseCase,
    uploadRecordUseCase: UploadRecordUseCase,
    recordId: Int
  ) -> any WriteContentDuringTheMissionReactor {
    return WriteContentDuringTheMissionReactorImp(
      coordinator: coordinator,
      saveRecordUseCase: saveRecordUseCase,
      uploadRecordUseCase: uploadRecordUseCase,
      recordId: recordId
    )
  }
  
  public func injectCameraShootDuringTheMissionViewController<T: CameraShootDuringTheMissionReactor>(
    reactor: T
  ) -> any CameraShootDuringTheMissionViewController {
    return CameraShootDuringTheMissionViewControllerImp(
      reactor: reactor
    )
  }
  
  public func injectWriteContentDuringTheMissionViewController<T: WriteContentDuringTheMissionReactor>(
    reactor: T,
    capturedImage: UIImage
  ) -> any WriteContentDuringTheMissionViewController {
    return WriteContentDuringTheMissionViewControllerImp(
      reactor: reactor,
      capturedImage: capturedImage
    )
  }
  
}
