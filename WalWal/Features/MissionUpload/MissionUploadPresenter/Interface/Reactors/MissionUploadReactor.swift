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

public enum MissionUploadReactorAction {
  
}

public enum MissionUploadReactorMutation {
  
}

public struct MissionUploadReactorState {
  public init() {
  
  }
}

public protocol MissionUploadReactor: Reactor where Action == MissionUploadReactorAction, Mutation == MissionUploadReactorMutation, State == MissionUploadReactorState {
  
  var coordinator: any __Coordinator { get }
  
  init(
    coordinator: any __Coordinator
  )
}
