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
  
  public init(
    coordinator: any MissionCoordinator
  ) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadMission:
      return Observable.concat([
        Observable.just(Mutation.setLoading(true)),
        fetchMissionData().map { Mutation.setMission($0) },
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
    }
    return newState
  }
  
  private func fetchMissionData() -> Observable<MissionModel> {
    /// 더미데이터
    let mission = MissionModel(title: "반려동물과 함께\n산책한 사진을 찍어요",
                               isStartMission: false,
                               imageURL: "",
                               date: 123,
                               backgroundColorCode: "FFDD77")
    return Observable.just(mission).delay(.seconds(1), scheduler: MainScheduler.instance)
  }
}
