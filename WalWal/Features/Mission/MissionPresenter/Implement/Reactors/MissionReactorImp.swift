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
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadMissionInfo:
      return Observable.concat([
        Observable.just( Mutation.setLoading(true)),
        fetchMissionDataAndCount(),
        Observable.just(Mutation.setLoading(false))
      ])
    case let .startMission(id):
      return startMission(id: id)
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
        newState.buttonText = "\(calculateTimeRemainingUntilMidnight())"
      case .completed:
        newState.buttonText = "내 미션 기록 보기"
      }
    case .setMissionCount(let count):
      newState.totalMissionCount = count
    case .missionLoadFailed:
      newState.isLoading = false
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
}
