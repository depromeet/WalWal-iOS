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
  case loadInitialData
  case moveToMissionUpload
}

public enum MissionReactorMutation {
  case fetchTodayMissionData(MissionModel) /// 오늘의 미션 불러오기
  case fetchRecordStatusData(MissionRecordStatusModel) /// 현재 미션 수행 상태
  case fetchCompletedRecordsTotalCountData(Int)
  case loadInitialDataFlowFailed(Error) /// 최초 네트워크 통신 흐름 실패 여부
  case startMissionUpload
}


public struct MissionReactorState {
  public var mission: MissionModel?
  public var recordId: Int = 0
  public var recordStatus: MissionRecordStatusModel?
  public var totalCompletedRecordsCount: Int = 0
  public var loadInitialDataFlowFailed: Error?
  
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
