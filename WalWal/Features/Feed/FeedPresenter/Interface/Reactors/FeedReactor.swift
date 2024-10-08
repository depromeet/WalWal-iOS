//
//  FeedReactor.swift
//
//  Feed
//
//  Created by 이지희
//

import FeedDomain
import FeedCoordinator

import RecordsDomain

import DesignSystem
import GlobalState

import ReactorKit
import RxSwift

public enum FeedReactorAction {
  case loadFeedData(cursor: String?)
  case refresh(cursor: String?)
  case endedBoost(recordId: Int, count: Int)
  case profileTapped(WalWalFeedModel)
  case checkScrollItem
  case doubleTap(Int?)
  case menuTapped(recordId: Int)
  case commentTapped(recordId: Int)
}

public enum FeedReactorMutation {
  case feedFetchFailed(error: String)
  case feedReachEnd(feedData: [WalWalFeedModel])
  case feedLoadEnded(nextCursor: String?, feedData: [WalWalFeedModel])
  case updateBoost
  case moveToProfile(memberId: Int, nickName: String)
  case scrollToFeedItem(id: Int?)
  case scrollToTop(Bool)
  case resetTabEvent
  case showMenu(recordId: Int)
  case moveToComment(recordId: Int)
}

public struct FeedReactorState {
  @Pulse public var feedErrorMessage: String = ""
  public var feedData: [WalWalFeedModel] = []
  public var nextCursor: String? = nil
  public var feedFetchEnded: Bool = false
  @Pulse public var scrollToFeedItem: Int? = nil
  public var isDoubleTap: Bool = false
  public init() {  }
}

public protocol FeedReactor: Reactor where Action == FeedReactorAction, Mutation == FeedReactorMutation, State == FeedReactorState {
  
  var coordinator: any FeedCoordinator { get }
  
  init(
    coordinator: any FeedCoordinator,
    fetchFeedUseCase: FetchFeedUseCase,
    updateBoostCountUseCase: UpdateBoostCountUseCase,
    removeGlobalRecordIdUseCase: RemoveGlobalRecordIdUseCase
  )
}
