//
//  ReportTypeReactor.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FeedCoordinator
import ReactorKit

public enum ReportTypeReactorAction {
  case didPan(translation: CGPoint, velocity: CGPoint)
  case didEndPan(velocity: CGPoint)
  case tapDimView
  case tapReportItem(item: ReportType)
}

public enum ReportTypeReactorMutation {
  case setSheetPosition(CGFloat)
  case dismissSheet
  case moveDetailView(type: String)
}

public struct ReportTypeReactorState {
  public let recordId: Int
  public var sheetPosition: CGFloat = 0
  public init(
    recordId: Int
  ) {
    self.recordId = recordId
  }
}

public protocol ReportTypeReactor: Reactor
where Action == ReportTypeReactorAction,
      Mutation == ReportTypeReactorMutation,
      State == ReportTypeReactorState {
  var coordinator: any FeedCoordinator { get }
  
  init(
    coordinator: any FeedCoordinator,
    recordId: Int
  )
}
