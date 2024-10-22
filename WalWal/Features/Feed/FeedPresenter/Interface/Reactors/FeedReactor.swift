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
  case commentTapped(recordId: Int, writerNickname: String)
  case refreshFeedData(Int, Int)
}

public enum FeedReactorMutation {
  case feedFetchFailed(error: String)
  case feedReachEnd(feedData: [WalWalFeedModel])
  case feedLoadEnded(nextCursor: String?, feedData: [WalWalFeedModel])
  case moveToProfile(memberId: Int, nickName: String)
  case scrollToFeedItem(id: Int?)
  case scrollToTop
  case showMenu(recordId: Int)
  case moveToComment(recordId: Int, writerNickname: String, commentId: Int?=nil)
  case updateFeed(recordId: Int, commentCount: Int)
}

public struct FeedReactorState {
  @Pulse public var feedErrorMessage: String = ""
  public var feedData: [WalWalFeedModel] = []
  @Pulse public var updatedFeed: WalWalFeedModel? = nil
  public var nextCursor: String? = nil
  public var feedFetchEnded: Bool = false
  @Pulse public var scrollToFeedItem: Int? = nil
  @Pulse public var tabBarTapped: Void? = nil
  @Pulse public var updatedCommentCount: (Int, Int)? = nil
  public init() {  }
}
 
public protocol FeedReactor: Reactor where Action == FeedReactorAction, Mutation == FeedReactorMutation, State == FeedReactorState {
  
  var coordinator: any FeedCoordinator { get }
  
  init(
    coordinator: any FeedCoordinator,
    fetchFeedUseCase: FetchFeedUseCase,
    updateBoostCountUseCase: UpdateBoostCountUseCase,
    removeGlobalRecordIdUseCase: RemoveGlobalRecordIdUseCase,
    fetchSingleFeedUseCase: FetchSingleFeedUseCase
  )
}
