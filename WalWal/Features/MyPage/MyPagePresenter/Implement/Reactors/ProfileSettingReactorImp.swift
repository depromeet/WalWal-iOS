//
//  ProfileSettingReactorImp.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/3/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageDomain
import MyPagePresenter
import MyPageCoordinator

import ReactorKit
import RxSwift

public final class ProfileSettingReactorImp: ProfileSettingReactor {
  public typealias Action = ProfileSettingReactorAction
  public typealias Mutation = ProfileSettingReactorMutation
  public typealias State = ProfileSettingReactorState
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  
  public init(
    coordinator: any MyPageCoordinator
  ) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    
  }
}
