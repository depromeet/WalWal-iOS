//
//  ReportReactorImp.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

import FeedPresenter
import FeedCoordinator

import ReactorKit

public final class ReportTypeReactorImp: ReportTypeReactor {
  
  public typealias Action = ReportTypeReactorAction
  public typealias Mutation = ReportTypeReactorMutation
  public typealias State = ReportTypeReactorState
  
  public let initialState: State
  public let coordinator: any FeedCoordinator
  
  public init(
    coordinator: any FeedCoordinator,
    recordId: Int
  ) {
    self.initialState = State(recordId: recordId)
    self.coordinator = coordinator
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .tapReportItem(item):
      return .just(.moveDetailView(type: item.title))
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .moveDetailView(type):
      coordinator.destination.accept(
        .showReportDetailView(
          recordId: state.recordId,
          reportType: type
        )
      )
    }
    return newState
  }
}
