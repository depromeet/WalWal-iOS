//
//  RecordDetailReactorImp.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageDomain
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
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchFeed: 
      break
//      return feedService.fetchFeed()
//        .map { feedData in
//          return Mutation.setFeedData(feedData)
//        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setFeedData(feedData):
      newState.feedData = feedData
    }
    return newState
  }
}
