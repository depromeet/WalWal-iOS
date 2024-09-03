//
//  FCMReactorImp.swift
//
//  FCM
//
//  Created by 이지희
//

import FCMDomain
import FCMPresenter
import FCMCoordinator

import ReactorKit
import RxSwift

public final class FCMReactorImp: FCMReactor {
  public typealias Action = FCMReactorAction
  public typealias Mutation = FCMReactorMutation
  public typealias State = FCMReactorState
  
  public let initialState: State
  public let coordinator: any FCMCoordinator
  private let fetchFCMListUseCase: FetchFCMListUseCase
  
  public init(
    coordinator: any FCMCoordinator,
    fetchFCMListUseCase: FetchFCMListUseCase
  ) {
    self.coordinator = coordinator
    self.initialState = State()
    self.fetchFCMListUseCase = fetchFCMListUseCase
  }
  
  public func transform(action: Observable<Action>) -> Observable<Action> {
    let loadFCMList = Observable.just(Action.loadFCMList)
    return Observable.merge(action, loadFCMList)
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadFCMList:
      return fetchFCMListUseCase.execute()
        .flatMap { data -> Observable<Mutation> in
          let section = [
            FCMSectionModel(section: 0, items: data),
            FCMSectionModel(section: 1, items: [])
          ]
          return .just(.loadFCMList(data: section))
        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .loadFCMList(data):
      newState.listData = data
    }
    return newState
  }
}
