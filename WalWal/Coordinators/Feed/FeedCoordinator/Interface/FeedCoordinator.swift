//
//  FeedCoordinatorInterface.swift
//
//  Feed
//
//  Created by 이지희
//

import UIKit
import BaseCoordinator

public enum FeedCoordinatorAction: ParentAction {
  case startProfile(memberId: Int, nickName: String)
}

public enum FeedCoordinatorFlow: CoordinatorFlow {
  case showFeedMenu(recordId: Int)
  case showReportView(recordId: Int)
  case showReportDetailView(recordId: Int, reportType: String)
  case showCommentView(recordId: Int, writerNickname: String, commentId: Int?=nil)
}

public protocol FeedCoordinator: BaseCoordinator
where Flow == FeedCoordinatorFlow,
      Action == FeedCoordinatorAction
{
  func startProfile(memberId: Int, nickName: String)
  func doubleTap(index: Int)
  func startReport(recordId: Int)
  func popReportDetail()
  func showComment(recordId: Int, writerNickname: String, commentId: Int?)
}
