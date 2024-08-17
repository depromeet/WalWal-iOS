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

import ReactorKit
import RxSwift

public final class MissionReactorImp: MissionReactor {
  public typealias Action = MissionReactorAction
  public typealias Mutation = MissionReactorMutation
  public typealias State = MissionReactorState
  
  public let initialState: State
  public let coordinator: any MissionCoordinator
  public let todayMissionUseCase: any TodayMissionUseCase
  
  public init(
    coordinator: any MissionCoordinator,
    todayMissionUseCase: any TodayMissionUseCase
  ) {
    self.coordinator = coordinator
    self.todayMissionUseCase = todayMissionUseCase
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
      return Observable.empty()
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
    }
    return newState
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
