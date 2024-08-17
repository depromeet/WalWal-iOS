//
//  MissionReactor.swift
//
//  Mission
//
//  Created by 이지희
//

import MissionCoordinator

import ReactorKit
import RxSwift
import MissionDomain

public enum MissionReactorAction {
  case loadMission
  case startMission
}

public enum MissionReactorMutation {
  case setMission(MissionModel)
  case setLoading(Bool)
}

public struct MissionReactorState {
  public var mission: MissionModel?
  public var isLoading: Bool = false
  
  public init() {
    
  }
}

public protocol MissionReactor: Reactor where Action == MissionReactorAction, Mutation == MissionReactorMutation, State == MissionReactorState {
  
  var coordinator: any MissionCoordinator { get }
  
  init(
    coordinator: any MissionCoordinator,
    todayMissionUseCase: any TodayMissionUseCase
  )
}
