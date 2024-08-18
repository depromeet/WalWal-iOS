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
    case .loadMissionInfo:
      return Observable.concat([
        Observable.just( Mutation.setLoading(true)),
        fetchMissionData()
          .flatMap { mutation -> Observable<Mutation> in
            if case let .setMission(mission) = mutation {
              return self.checkMissionStatus(id: mission.id).startWith(mutation)
            }
            return Observable.just(mutation)
          },
        fetchMissionCount(),
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
      newState.isMissionStarted = status.statusMessage == .completed
      newState.missionStatus = status
    case .setMissionCount(let count):
      newState.totalMissionCount = count
    case .missionLoadFailed:
      newState.isLoading = false
    }
    return newState
  }
  
  private func fetchMissionCount() -> Observable<Mutation> {
    return checkCompletedTotalRecordsUseCase.execute()
      .asObservable()
      .map {
        return Mutation.setMissionCount($0.totalCount)
      }
      .catch { error in
        Observable.just(Mutation.missionLoadFailed(error))
      }
  }
  
  
  private func startMission(id: Int) -> Observable<Mutation> {
    return startRecordUseCase.execute(missionId:id)
      .asObservable()
      .map { _ in
        return Mutation.missionStarted
      }
      .catch { error in
        return Observable.just(Mutation.missionLoadFailed(error))
      }
  }
  
  private func checkMissionStatus(id: Int) -> Observable<Mutation> {
    return checkRecordStatusUseCase.execute(missionId: id)
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
