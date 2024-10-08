//
//  ReportDetailReactor.swift
//  FeedPresenter
//
//  Created by Jiyeon on 10/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FeedCoordinator
import FeedDomain

import ReactorKit

public enum ReportDetailReactorAction {
  case didPan(translation: CGPoint, velocity: CGPoint)
  case didEndPan(velocity: CGPoint)
  case backButtonTapped
  case dismissView
  case submitTapped(details: String?)
}

public enum ReportDetailReactorMutation {
  case setSheetPosition(CGFloat)
  case dismissSheet
  case backButtonTapped
  case sheetDown
  case showAlert
  case showIndicator(Bool)
  case showErrorToast(String)
}

public struct ReportDetailReactorState {
  public var recordId: Int
  public var reportType: String
  public var sheetPosition: CGFloat = 0
  public var sheetDown: Bool = false
  public var showIndicator: Bool = false
  public var showAlert: Bool = false
  public var showErrorToast: String? = nil
  
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
    reportUseCase: ReportUseCase,
    recordId: Int,
    reportType: String
  )
}
