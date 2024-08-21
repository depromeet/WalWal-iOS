//
//  MissionUploadDependencyFactoryInterface.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import UIKit

import RecordsDependencyFactory
import ImageDependencyFactory

import BaseCoordinator
import MissionUploadCoordinator

import MissionUploadDomain
import MissionUploadPresenter

import RecordsDomain
import ImageDomain

public protocol MissionUploadDependencyFactory {
  
  func injectMissionUploadCoordinator(
    navigationController: UINavigationController,
    parentCoordinator:( any BaseCoordinator)?,
    recordsDependencyFactory: RecordsDependencyFactory,
    imageDependencyFactory: ImageDependencyFactory
  ) -> any MissionUploadCoordinator
  
  func injectCameraShootDuringTheMissionReactorReactor<T: MissionUploadCoordinator>(
    coordinator: T
  ) -> any CameraShootDuringTheMissionReactor
  
  func injectWriteContentDuringTheMissionReactor<T: MissionUploadCoordinator>(
    coordinator: T,
    saveRecordUseCase: SaveRecordUseCase,
    uploadRecordUseCase: UploadRecordUseCase
  ) -> any WriteContentDuringTheMissionReactor
  
  func injectCameraShootDuringTheMissionViewController<T: CameraShootDuringTheMissionReactor>(
    reactor: T
  ) -> any CameraShootDuringTheMissionViewController
  
  func injectWriteContentDuringTheMissionViewController<T: WriteContentDuringTheMissionReactor>(
    reactor: T
  ) -> any WriteContentDuringTheMissionViewController
  
}
