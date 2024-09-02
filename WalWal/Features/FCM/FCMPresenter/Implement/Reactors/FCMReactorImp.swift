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
  private let fcmListUseCase: FCMListUseCase
  
  public init(
    coordinator: any FCMCoordinator,
    fcmListUseCase: FCMListUseCase
  ) {
    self.coordinator = coordinator
    self.initialState = State()
    self.fcmListUseCase = fcmListUseCase
  }
  
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadFCMList:
      return .never()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .loadFCMList:
      break
    }
    return newState
  }
}
