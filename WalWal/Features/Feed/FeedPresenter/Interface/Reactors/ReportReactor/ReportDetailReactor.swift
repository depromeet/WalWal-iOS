//
//  ReportDetailReactor.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FeedCoordinator
import ReactorKit

public enum ReportDetailReactorAction {
  case didPan(translation: CGPoint, velocity: CGPoint)
  case didEndPan(velocity: CGPoint)
  case backButtonTapped
  case tapDimView

}

public enum ReportDetailReactorMutation {
  case setSheetPosition(CGFloat)
  case dismissSheet
  case backButtonTapped
}

public struct ReportDetailReactorState {
  public var recordId: Int
  public var reportType: String
  public var sheetPosition: CGFloat = 0

  public init(
    recordId: Int,
    reportType: String
  ) {
    self.recordId = recordId
    self.reportType = reportType
  }
}

public protocol ReportDetailReactor: Reactor where Action == ReportDetailReactorAction, Mutation == ReportDetailReactorMutation, State == ReportDetailReactorState {
  
  var coordinator: any FeedCoordinator { get }
  
  init(
    coordinator: any FeedCoordinator,
    recordId: Int,
    reportType: String
  )
}