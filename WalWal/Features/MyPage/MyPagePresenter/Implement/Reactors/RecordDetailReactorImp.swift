//
//  RecordDetailReactorImp.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageDomain
import MyPagePresenter
import MyPageCoordinator

import ReactorKit
import RxSwift

public final class RecordDetailReactorImp: RecordDetailReactor {
  
  public typealias Action = RecordDetailReactorAction
  public typealias Mutation = RecordDetailReactorMutation
  public typealias State = RecordDetailReactorState
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  
  public init(
    coordinator: any MyPageCoordinator
  ) {
    
    self.initialState = State()
    self.coordinator = coordinator
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
  }
}
