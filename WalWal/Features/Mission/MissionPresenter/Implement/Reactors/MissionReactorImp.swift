//
//  MissionReactorImp.swift
//
//  Mission
//
//  Created by 이지희
//

import UIKit
import MissionPresenter
import MissionCoordinator
import MissionDomain
import RecordsDomain
import Utility
import DesignSystem

import ReactorKit
import RxSwift

public final class MissionReactorImp: MissionReactor {
  public typealias Action = MissionReactorAction
  public typealias Mutation = MissionReactorMutation
  public typealias State = MissionReactorState
  
  private var timerDisposeBag = DisposeBag()
  
  public let initialState: State
  public let coordinator: any MissionCoordinator
  private let todayMissionUseCase: TodayMissionUseCase
  private let checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase
  private let checkRecordStatusUseCase: CheckRecordStatusUseCase
  private let checkRecordCalendarUseCase: CheckCalendarRecordsUseCase
  private let removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase
  private let startRecordUseCase: StartRecordUseCase
  
  private let disposeBag = DisposeBag()
  
  public init(
    coordinator: any MissionCoordinator,
    todayMissionUseCase: TodayMissionUseCase,
    checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase,
    checkRecordStatusUseCase: CheckRecordStatusUseCase,
    checkRecordCalendarUseCase: CheckCalendarRecordsUseCase,
    removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase,
    startRecordUseCase: StartRecordUseCase
  ) {
    self.coordinator = coordinator
    self.todayMissionUseCase = todayMissionUseCase
    self.checkCompletedTotalRecordsUseCase = checkCompletedTotalRecordsUseCase
    self.checkRecordStatusUseCase = checkRecordStatusUseCase
    self.checkRecordCalendarUseCase = checkRecordCalendarUseCase
    self.removeGlobalCalendarRecordsUseCase = removeGlobalCalendarRecordsUseCase
    self.startRecordUseCase = startRecordUseCase
    self.initialState = State()
  }
  
  public func transform(action: Observable<Action>) -> Observable<Action> {
    let initialAction = Observable.just(Action.loadInitialData)
    return Observable.merge(action, initialAction)
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .refreshMissionData:
      return loadMidnightMissionData()
    case .loadInitialData:
      return loadAllMissionData()
    case .moveToMissionUpload:
      guard let mission = currentState.mission else { return .empty() }
      return startRecord(missionId: mission.id)
        .map { Mutation.fetchRecordId($0) }
        .concat(Observable.just(Mutation.startMissionUploadProcess))
        .catch { error in Observable.just(Mutation.moveToMissionUploadFailed(error)) }
    case .startTimer:
      return startTimer()
    case .stopTimer:
      return .just(Mutation.stopTimer)
    case .moveToMyPage:
      return .just(.moveToMyPage)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
      
    // MARK: - 미션탭 처음 들어오면 실행되는 Flow!
    case let .fetchTodayMissionData(mission):
      newState.loadInitialDataFlowEnded = false
      newState.mission = mission
    case let .fetchRecordStatusData(recordStatus):
      newState.recordStatus = recordStatus
      if case .inProgress = recordStatus.statusMessage {
        newState.isTimerRunning = true
      } else {
        newState.isTimerRunning = false
        newState.buttonTitle = recordStatus.statusMessage.description
      }
    case let .updateTimerText(text):
      guard newState.recordStatus != nil else { return newState }
      newState.buttonTitle = text
    case .stopTimer:
      newState.isTimerRunning = false
      guard let status = newState.recordStatus else { return newState }
      newState.buttonTitle = status.statusMessage.description
    case let .fetchCompletedRecordsTotalCountData(totalCount):
      newState.totalCompletedRecordsCount = totalCount
    case .loadInitialDataFlowEnded:
      newState.loadInitialDataFlowEnded = true
    case .loadInitialDataFlowFailed(let loadInitialDataFlowFailed):
      newState.loadInitialDataFlowFailed = loadInitialDataFlowFailed
    
    // MARK: - 미션 시작하기를 누르면 실행되는 Flow!
    case let .fetchRecordId(recordId):
      newState.recordId = recordId
    case.startMissionUploadProcess:
      guard let mission = newState.mission else { return newState }
      coordinator.destination.accept(
        .startMissionUpload(
          recordId: newState.recordId,
          missionId: mission.id
        )
      )
    case let .moveToMissionUploadFailed(error):
      newState.missionUploadError = error
    case .moveToMyPage:
      coordinator.startMyPage()
    }
    return newState
  }
  
  private func loadAllMissionData() -> Observable<Mutation> {
    return checkRecordCalendar()
      .flatMap { _ in self.fetchMissionData()}
      .flatMap { [weak self] mission -> Observable<Mutation> in
        guard let owner = self else { return .empty() }
        return .concat([
          .just(Mutation.fetchTodayMissionData(mission)),
          owner.fetchRecordStatus(missionId: mission.id),
          owner.fetchCompletedTotalRecordsCount(),
          .just(Mutation.loadInitialDataFlowEnded)
        ])
      }
      .catch { error in
        return Observable.just(Mutation.loadInitialDataFlowFailed(error))
      }
  }
  
  private func loadMidnightMissionData() -> Observable<Mutation> {
    return fetchMissionData()
      .flatMap { [weak self] mission -> Observable<Mutation> in
        guard let owner = self else { return .empty() }
        return .concat([
          .just(Mutation.fetchTodayMissionData(mission)),
          owner.fetchRecordStatus(missionId: mission.id),
          owner.fetchCompletedTotalRecordsCount(),
          .just(Mutation.loadInitialDataFlowEnded)
        ])
      }
      .catch { error in
        return Observable.just(Mutation.loadInitialDataFlowFailed(error))
      }
  }
  
  /// missions/today 정보 가져오기
  private func fetchMissionData() -> Observable<MissionModel> {
    return todayMissionUseCase.execute()
      .asObservable()
  }
  
  /// records/status 호출
  private func fetchRecordStatus(missionId: Int) -> Observable<Mutation> {
    return checkRecordStatusUseCase.execute(missionId: missionId)
      .asObservable()
      .map { return Mutation.fetchRecordStatusData($0) }
      .catch { error in
        return Observable.just(Mutation.loadInitialDataFlowFailed(error))
      }
  }
  
  /// records/completed/total 호출
  private func fetchCompletedTotalRecordsCount() -> Observable<Mutation> {
    return checkCompletedTotalRecordsUseCase.execute(memberId: nil)
      .asObservable()
      .map { return Mutation.fetchCompletedRecordsTotalCountData($0.totalCount) }
      .catch { error in
        return Observable.just(Mutation.loadInitialDataFlowFailed(error))
      }
  }
  
  /// records/start 호출
  private func startRecord(missionId: Int) -> Observable<Int> {
    return startRecordUseCase.execute(missionId: missionId)
      .asObservable()
      .map { $0.recordId }
  }
  
  /// 캘린더 정보도 여기서 업뎃 치자
  private func checkRecordCalendar() -> Observable<Void> {
    /// 우선 저장되어 있는 GlobalRecords 지우고, 새로운 calendar fetch
    return removeGlobalCalendarRecordsUseCase.execute()
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in owner.fetchCalendarRecords(cursor: "2024-01-01", limit: 30) }
  }
  
  /// records/calendar 호출
  private func fetchCalendarRecords(cursor: String, limit: Int) -> Observable<Void> {
    return checkRecordCalendarUseCase.execute(cursor: cursor, limit: limit)
      .asObservable()
      .flatMap { calendarModel -> Observable<Void> in
        if let nextCursor = calendarModel.nextCursor.nextCursor {
          return self.fetchCalendarRecords(cursor: nextCursor, limit: limit)
        } else {
          return .just(Void())
        }
      }
      .catch { error in return .just(Void()) }
  }
  
  // MARK: - MissionTimer
  
  private func startTimer() -> Observable<Mutation> {
    timerDisposeBag = DisposeBag()
    return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
      .map { _ in Mutation.updateTimerText(self.calculateTimeRemainingUntilMidnight()) }
      .take(until: self.state.filter { $0.recordStatus?.statusMessage != .inProgress })
      .do(onDispose: { [weak self] in
        self?.timerDisposeBag = DisposeBag()
      })
  }
  
  private func calculateTimeRemainingUntilMidnight() -> String {
    let calendar = Calendar.current
    let now = Date()
    let midnight = calendar.startOfDay(for: now).addingTimeInterval(86400)
    let components = calendar.dateComponents([.hour, .minute, .second], from: now, to: midnight)
    guard let hour = components.hour, let minute = components.minute, let second = components.second else {
      return "남은 시간 계산 실패"
    }
    if hour == 0 && minute == 0 && second == 0 {
      action.onNext(.refreshMissionData)
    }
    return String(format: "%02d:%02d:%02d 남았어요!", hour, minute, second)
  }
  
  /// 알림 권한 확인
  private func checkNotificationPermission() -> Observable<Bool> {
    return PermissionManager.shared.checkPermission(for: .notification)
      .flatMap { isGranted in
        if !isGranted {
          return PermissionManager.shared.requestNotificationPermission()
        }
        return Observable.just(isGranted)
      }
  }
  
  /// 미션 시작 전 카메라 권한 확인
  private func startMission() {
    PermissionManager.shared.checkPermission(for: .camera)
      .subscribe(with: self, onNext: { owner, isGranted in
        if isGranted {
          // 미션 시작
        } else {
          PermissionManager.shared.requestCameraPermission()
            .subscribe(with: self, onNext: { owner, granted in
              if granted {
                // 미션 시작
              } else {
                // 권한 없음 -> 토스트 메시지로 권한 요청?
              }
            })
            .disposed(by: owner.disposeBag)
        }
      })
      .disposed(by: disposeBag)
  }
}
