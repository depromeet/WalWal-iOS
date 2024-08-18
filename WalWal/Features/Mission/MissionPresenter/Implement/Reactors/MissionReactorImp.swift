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
  
  public let initialState: State
  public let coordinator: any MissionCoordinator
  public let todayMissionUseCase: any TodayMissionUseCase
  public let checkCompletedTotalRecordsUseCase: any CheckCompletedTotalRecordsUseCase
  public let checkRecordStatusUseCase: any CheckRecordStatusUseCase
  public let startRecordUseCase: any StartRecordUseCase
  
  public init(
    coordinator: any MissionCoordinator,
    todayMissionUseCase: any TodayMissionUseCase,
    checkCompletedTotalRecordsUseCase: any CheckCompletedTotalRecordsUseCase,
    checkRecordStatusUseCase: any CheckRecordStatusUseCase,
    startRecordUseCase: any StartRecordUseCase
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
    case .loadMission:
      return Observable.concat([
        Observable.just(Mutation.setLoading(true)),
        fetchMissionData(),
        Observable.just(Mutation.setLoading(false))
      ])
    case .startMission:
      // Mission 시작 로직을 추가
      return startMission()
    case .checkMissionStatus:
      return checkMissionStatus()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .setMission(let mission):
      newState.mission = mission
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    case .missionLoadFailed(let error):
      newState.isLoading = false
      newState.error = error
    case .missionStarted:
      // 미션 시작 시의 상태 업데이트
      newState.isMissionStarted = true
    case .setMissionStatus(let status):
      newState.missionStatus = status
    }
    return newState
  }
  
  
  private func startMission() -> Observable<Mutation> {
    return startRecordUseCase.execute(missionId: 1)
      .asObservable()
      .map { _ in
        return Mutation.missionStarted
      }
      .catch { error in
        return Observable.just(Mutation.missionLoadFailed(error))
      }
  }
  
  private func checkMissionStatus() -> Observable<Mutation> {
    return checkRecordStatusUseCase.execute(missionId: 1)
      .asObservable()
      .map { status in
        return Mutation.setMissionStatus(status)
      }
      .catch { error in
        return Observable.just(Mutation.missionLoadFailed(error))
      }
  }
  
  
  private func fetchMissionData() -> Observable<Mutation> {
    return todayMissionUseCase.excute()
      .asObservable()
      .map { mission in
        return Mutation.setMission(mission)
      }
      .catch { error in
        return Observable.just(Mutation.missionLoadFailed(error))
      }
  }
}
