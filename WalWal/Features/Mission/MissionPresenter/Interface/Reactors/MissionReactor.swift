//
//  MissionReactor.swift
//
//  Mission
//
//  Created by 이지희
//

import MissionCoordinator

import MissionDomain
import RecordsDomain

import ReactorKit
import RxSwift

public enum MissionReactorAction {
  case loadMissionInfo
  case startMission
  case checkMissionStatus(Int)
}

public enum MissionReactorMutation {
  case setMission(MissionModel)
  case setLoading(Bool)
  case missionLoadFailed(Error)
  case missionStarted
  case setMissionStatus(MissionRecordStatusModel)
  case setMissionCount(Int)
}


public struct MissionReactorState {
  public var mission: MissionModel?
  public var isLoading: Bool = false
  public var isMissionStarted: Bool = false
  public var missionStatus: MissionRecordStatusModel?
  public var totalMissionCount : Int = 0
  
  public init() {
    
  }
}

public protocol MissionReactor: Reactor where Action == MissionReactorAction, Mutation == MissionReactorMutation, State == MissionReactorState {
  
  var coordinator: any MissionCoordinator { get }
  
  init(
    coordinator: any MissionCoordinator,
    todayMissionUseCase: any TodayMissionUseCase,
    checkCompletedTotalRecordsUseCase: any CheckCompletedTotalRecordsUseCase,
    checkRecordStatusUseCase: any CheckRecordStatusUseCase,
    startRecordUseCase: any StartRecordUseCase
  ) 
}
