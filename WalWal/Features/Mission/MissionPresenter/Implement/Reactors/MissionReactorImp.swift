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

import ReactorKit
import RxSwift

public final class MissionReactorImp: MissionReactor {
  public typealias Action = MissionReactorAction
  public typealias Mutation = MissionReactorMutation
  public typealias State = MissionReactorState
  
  private var timerDisposeBag = DisposeBag()
  
  public let initialState: State
  public let coordinator: any MissionCoordinator
  public let todayMissionUseCase: TodayMissionUseCase
  public let checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase
  public let checkRecordStatusUseCase: CheckRecordStatusUseCase
  public let startRecordUseCase: StartRecordUseCase
  
  private let disposeBag = DisposeBag()
  
  public init(
    coordinator: any MissionCoordinator,
    todayMissionUseCase: TodayMissionUseCase,
    checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase,
    checkRecordStatusUseCase: CheckRecordStatusUseCase,
    startRecordUseCase: StartRecordUseCase
  ) {
    self.coordinator = coordinator
    self.todayMissionUseCase = todayMissionUseCase
    self.checkCompletedTotalRecordsUseCase = checkCompletedTotalRecordsUseCase
    self.checkRecordStatusUseCase = checkRecordStatusUseCase
    self.startRecordUseCase = startRecordUseCase
    self.initialState = State()
  }
  
  public func transform(action: Observable<Action>) -> Observable<Action> {
    let initialLoadAction = Observable.just(Action.loadMissionInfo)
    let initialPermissionCheck = Observable.just(Action.checkPermission)
    
    return Observable.merge(action, initialLoadAction, initialPermissionCheck)
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadMissionInfo:
      return Observable.concat([
        Observable.just( Mutation.setLoading(true)),
        fetchMissionDataAndCount(),
        Observable.just(Mutation.setLoading(false))
      ])
    case .checkPermission:
      return checkNotificationPermission()
        .map { Mutation.setNotiPermission($0) }
    case let .startMission(id):
      startMission()
      return startMission(id: id)
    case .startTimer:
      return startMissionTimer()
    case .moveToMissionUpload:
      return Observable.just(Mutation.startMissionUpload)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setMission(let mission):
      newState.mission = mission
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    case .missionStarted:
      newState.isMissionStarted = true
    case .setMissionStatus(let status):
      newState.isMissionStarted = status.statusMessage == .inProgress || status.statusMessage == .completed
      newState.missionStatus = status
      switch status.statusMessage {
      case .notCompleted:
        newState.buttonText = "미션 시작하기"
      case .inProgress:
        startTimerObservable()
      case .completed:
        newState.buttonText = "내 미션 기록 보기"
      }
    case .setMissionCount(let count):
      newState.totalMissionCount = count
    case .missionLoadFailed:
      newState.isLoading = false
    case .setButtionText(let text):
      newState.buttonText = text
    case .setNotiPermission(let isAllow):
      newState.isAllowNoti = isAllow
    case .setCamPermission(let isAllow):
      newState.isAllowCamera = isAllow
    case .startMissionUpload:
      guard let missionState = newState.missionStatus else { return newState }
      guard let mission = newState.mission else { return newState }
      coordinator.destination.accept(.startMissionUpload(recordId: missionState.recordId, missionId: mission.id))
    }
    return newState
  }
  
  private func fetchMissionDataAndCount() -> Observable<Mutation> {
    return fetchMissionData()
      .flatMap { mutation -> Observable<Mutation> in
        if case let .setMission(mission) = mutation {
          return self.checkMissionStatus(id: mission.id)
            .map { status in
              return Mutation.setMissionStatus(status)
            }
            .startWith(mutation)
        }
        return Observable.just(mutation)
      }
      .flatMap { mutation -> Observable<Mutation> in
        return self.fetchMissionCount()
          .startWith(mutation)
      }
  }
  
  private func fetchMissionData() -> Observable<Mutation> {
    return todayMissionUseCase.execute()
      .asObservable()
      .map { mission in
        return Mutation.setMission(mission)
      }
      .catch { error in
        return Observable.just(Mutation.missionLoadFailed(error))
      }
  }
  
  private func checkMissionStatus(id: Int) -> Observable<MissionRecordStatusModel> {
    return checkRecordStatusUseCase.execute(missionId: id)
      .asObservable()
      .catch { error in
        return Observable.error(error)
      }
  }
  
  private func fetchMissionCount() -> Observable<Mutation> {
    return checkCompletedTotalRecordsUseCase.execute()
      .asObservable()
      .map {
        return Mutation.setMissionCount($0.totalCount)
      }
      .catch { error in
        return Observable.just(Mutation.missionLoadFailed(error))
      }
  }
  
  private func startMission(id: Int) -> Observable<Mutation> {
    return startRecordUseCase.execute(missionId: id)
      .asObservable()
      .map { _ in
        return Mutation.missionStarted
      }
      .catch { error in
        return Observable.just(Mutation.missionLoadFailed(error))
      }
  }
  
  // MARK: - MissionTimer
  private func calculateTimeRemainingUntilMidnight() -> String {
    let calendar = Calendar.current
    let now = Date()
    let midnight = calendar.startOfDay(for: now).addingTimeInterval(86400)
    
    let components = calendar.dateComponents([.hour, .minute, .second], from: now, to: midnight)
    
    guard let hour = components.hour, let minute = components.minute, let second = components.second else {
      return "남은 시간 계산 실패"
    }
    
    return String(format: "%02d:%02d:%02d 남았어요!", hour, minute, second)
  }
  
  
  private func startMissionTimer() -> Observable<Mutation> {
    let timerObservable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
      .startWith(0)
      .map { _ in return self.calculateTimeRemainingUntilMidnight() }
      .flatMap { time -> Observable<Mutation> in
        return Observable.from([Mutation.setButtionText(time)])
      }
    return timerObservable
  }
  private func startTimerObservable() {
    timerDisposeBag = DisposeBag()
    
    Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
      .startWith(0)
      .map { [weak self] _ in
        self?.calculateTimeRemainingUntilMidnight() ?? "00:00:00"
      }
      .map { Mutation.setButtionText($0) }
      .subscribe(with: self, onNext: { owner, mutation in
        owner.action.onNext(.startTimer)
      })
      .disposed(by: timerDisposeBag)
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
