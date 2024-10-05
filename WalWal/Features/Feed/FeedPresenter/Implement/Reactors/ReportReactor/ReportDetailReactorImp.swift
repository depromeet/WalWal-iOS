//
//  ReportDetailReactorImp.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//


import UIKit
import DesignSystem

import FeedDomain
import FeedPresenter
import FeedCoordinator

import ReactorKit

public final class ReportDetailReactorImp: ReportDetailReactor {
  
  public typealias Action = ReportDetailReactorAction
  public typealias Mutation = ReportDetailReactorMutation
  public typealias State = ReportDetailReactorState
  
  public let initialState: State
  public let coordinator: any FeedCoordinator
  
  private let reportUseCase: ReportUseCase
  
  public init(
    coordinator: any FeedCoordinator,
    reportUseCase: ReportUseCase,
    recordId: Int,
    reportType: String
  ) {
    self.initialState = State(recordId: recordId, reportType: reportType)
    self.coordinator = coordinator
    self.reportUseCase = reportUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .didPan(translation, _):
      return Observable.just(.setSheetPosition(translation.y))
    case let .didEndPan(velocity):
      if velocity.y > 1000 {
        return Observable.just(.dismissSheet)
      } else {
        return Observable.just(.setSheetPosition(0))
      }
    case .dismissView:
      return Observable.just(.dismissSheet)
    case .backButtonTapped:
      return .just(.backButtonTapped)
    case let .submitTapped(details):
      return .concat([
        .just(.showIndicator(true)),
        report(
          recordId: initialState.recordId,
          type: initialState.reportType,
          details: details
        )
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setSheetPosition(position):
      newState.sheetPosition = position
    case .dismissSheet:
      coordinator.dismissViewController(animated: false) { }
    case .backButtonTapped:
      coordinator.popReportDetail()
    case .sheetDown:
      newState.sheetDown = true
    case .showAlert:
      newState.showAlert = true
    case let .showIndicator(isShow):
      newState.showIndicator = isShow
    case let .showErrorToast(msg):
      newState.showErrorToast = msg
    }
    return newState
  }
  
}

extension ReportDetailReactorImp {
  private func report(recordId: Int, type: String, details: String?) -> Observable<Mutation> {
    return reportUseCase.execute(recordId: recordId, type: type, details: details)
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in
        return .concat([
          .just(.showIndicator(false)),
          .just(.sheetDown),
          .just(.showAlert)
        ])
      }
      .catch { error in
        return .concat([
          .just(.showIndicator(false)),
          .just(.showErrorToast(error.localizedDescription))
        ])
      }
  }
}

