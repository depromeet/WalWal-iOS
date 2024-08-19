//
//  MissionUploadReactor.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import MissionUploadDomain
import MissionUploadCoordinator

import ReactorKit
import RxSwift

public enum CameraShootDuringTheMissionReactorAction {
  
}

public enum CameraShootDuringTheMissionReactorMutation {
  
}

public struct CameraShootDuringTheMissionReactorState {
  public init() {
  
  }
}

public protocol CameraShootDuringTheMissionReactor: Reactor where
Action == CameraShootDuringTheMissionReactorAction,
Mutation == CameraShootDuringTheMissionReactorMutation,
State == CameraShootDuringTheMissionReactorState {
  
  var coordinator: any MissionUploadCoordinator { get }
  
  init(
    coordinator: any MissionUploadCoordinator
  )
}
