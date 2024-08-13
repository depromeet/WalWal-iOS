//
//  ProfileEditReactorImp.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageDomain
import MyPagePresenter
import MyPageCoordinator

import ReactorKit
import RxSwift

public final class ProfileEditReactorImp: ProfileEditReactor {
  
  public typealias Action = ProfileEditReactorAction
  public typealias Mutation = ProfileEditReactorMutation
  public typealias State = ProfileEditReactorState
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  
  public init(
    coordinator: any MyPageCoordinator
  ) {
    
    self.initialState = State()
    self.coordinator = coordinator
  }
  
  // TODO: 유효성 체크로 변경 필요
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .checkCondition(nickname):
      return .just(.showIndicator(show: true))
    case let .editProfile(nickname, profileURL):
      return .concat([
        .just(.showIndicator(show: true)),
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .buttonEnable(isEnable):
      newState.buttonEnable = isEnable
    case let .invaildNickname(message):
      newState.invaildMessage = message
    case let .showIndicator(show):
      newState.showIndicator = show
    }
    return newState
  }
  
  
  private func checkNickname(nickname: String) {
    
  }
}