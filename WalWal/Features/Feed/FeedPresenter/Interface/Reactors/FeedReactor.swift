//
//  FeedReactor.swift
//
//  Feed
//
//  Created by 이지희
//

import FeedDomain
import FeedCoordinator
import DesignSystem
import GlobalState

import ReactorKit
import RxSwift

public enum FeedReactorAction {
  case loadFeedData(cursor: String?)
  case refresh(cursor: String?)
}

public enum FeedReactorMutation {
  case feedFetchFailed(error: String)
  case feedReachEnd(feedData: [WalWalFeedModel])
  case feedLoadEnded(nextCursor: String?, feedData: [WalWalFeedModel])
}

public struct FeedReactorState {
  public init() {  }
  public var feedData: [WalWalFeedModel] = []
  @Pulse public var feedErrorMessage: String = ""
  public var nextCursor: String? = nil
  public var feedFetchEnded: Bool = false
}

public protocol FeedReactor: Reactor where Action == FeedReactorAction, Mutation == FeedReactorMutation, State == FeedReactorState {
  
  var coordinator: any FeedCoordinator { get }
  
  init(
    coordinator: any FeedCoordinator,
    fetchFeedUseCase: FetchFeedUseCase
  )
}
