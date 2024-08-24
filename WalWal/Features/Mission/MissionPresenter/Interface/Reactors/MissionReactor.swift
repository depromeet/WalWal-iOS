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
  case startMission(Int)
  case startTimer
  case moveToMissionUpload
  case checkPermission
}

public enum MissionReactorMutation {
  case setMission(MissionModel)
  case setLoading(Bool)
  case missionLoadFailed(Error)
  case missionStarted(MissionRecordStartModel)
  case setMissionStatus(MissionRecordStatusModel)
  case setMissionCount(Int)
  case setButtionText(String)
  case setNotiPermission(Bool)
  case setCamPermission(Bool)
  case startMissionUpload
}


public struct MissionReactorState {
  public var mission: MissionModel?
  public var isLoading: Bool = false
  public var isMissionStarted: Bool = false
  public var missionStatus: MissionRecordStatusModel?
  public var totalMissionCount : Int = 0
  public var buttonText: String = "미션 시작하기" // 초기값
  public var recordId: Int = 0
  public var isAllowNoti: Bool = false
  public var isAllowCamera: Bool = false
  
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
