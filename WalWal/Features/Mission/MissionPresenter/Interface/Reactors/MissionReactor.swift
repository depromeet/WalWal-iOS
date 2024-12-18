//
//  MissionReactor.swift
//
//  Mission
//
//  Created by 이지희
//

import UIKit
import MissionCoordinator

import MissionDomain
import RecordsDomain
import FCMDomain

import ReactorKit
import RxSwift

public enum MissionReactorAction {
  case loadInitialData
  case moveToMissionUpload
  case startTimer
  case stopTimer
  case moveToMyPage
  case refreshMissionData
  case appWillEnterForeground
  case moveToMissionGallery(UIImage)
}

public enum MissionReactorMutation {
  case fetchTodayMissionData(MissionModel) /// 오늘의 미션 불러오기
  case fetchRecordStatusData(MissionRecordStatusModel) /// 현재 미션 수행 상태
  case fetchCompletedRecordsTotalCountData(Int)
  case loadInitialDataFlowEnded /// 최초 네트워크 통신 흐름 종료
  case loadInitialDataFlowFailed(Error) /// 최초 네트워크 통신 흐름 실패 여부
  
  case updateTimerText(String)
  case stopTimer
  
  case fetchRecordId(Int) /// recordId를 저장
  case selectMissionMethod
  case startMissionUploadProcess(UIImage)
  case moveToMissionUploadFailed(Error) /// 미션 업로드 화면으로 이동 실패
  case moveToMyPage
  case isNeedRequestPermission(Bool)
}


public struct MissionReactorState {
  public var mission: MissionModel?
  public var recordId: Int = 0
  public var recordStatus: MissionRecordStatusModel?
  public var totalCompletedRecordsCount: Int = 0
  public var loadInitialDataFlowEnded: Bool = false
  public var loadInitialDataFlowFailed: Error?
  public var missionUploadError: Error?
  
  public var isTimerRunning: Bool = false
  public var buttonTitle: String = "미션 시작하기"
  
  @Pulse public var isNeedRequestPermission: Bool = false
  public init() {
    
  }
}

public protocol MissionReactor: Reactor where Action == MissionReactorAction, Mutation == MissionReactorMutation, State == MissionReactorState {
  
  var coordinator: any MissionCoordinator { get }
  
  init(
    coordinator: any MissionCoordinator,
    todayMissionUseCase: TodayMissionUseCase,
    checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase,
    checkRecordStatusUseCase: CheckRecordStatusUseCase,
    checkRecordCalendarUseCase: CheckCalendarRecordsUseCase,
    removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase,
    startRecordUseCase: StartRecordUseCase,
    removeGlobalFCMListUseCase: RemoveGlobalFCMListUseCase
  )
}
