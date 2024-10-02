//
//  ReportDetailReactorImp.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//


import UIKit

import FeedPresenter
import FeedCoordinator

import ReactorKit

public final class ReportDetailReactorImp: ReportDetailReactor {
  
  public typealias Action = ReportDetailReactorAction
  public typealias Mutation = ReportDetailReactorMutation
  public typealias State = ReportDetailReactorState
  
  public let initialState: State
  public let coordinator: any FeedCoordinator
  
  public init(
    coordinator: any FeedCoordinator,
    recordId: Int,
    reportType: String
  ) {
    self.initialState = State(recordId: recordId, reportType: reportType)
    self.coordinator = coordinator
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .backButtonTapped:
      return .just(.backButtonTapped)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    
    switch mutation {
    case .backButtonTapped:
      coordinator.popReportDetail()
    }
    return state
  }
}

