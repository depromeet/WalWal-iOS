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

import ReactorKit
import RxSwift

public enum FeedReactorAction {
  case loadFeedData(cursor: String, limits: Int)
}

public enum FeedReactorMutation {
 case setFeedData([WalWalFeedModel])
}

public struct FeedReactorState {
  public init() {  }
  public var feedData: [WalWalFeedModel] = []
}

public protocol FeedReactor: Reactor where Action == FeedReactorAction, Mutation == FeedReactorMutation, State == FeedReactorState {

  var coordinator: any FeedCoordinator { get }
  
  init(
    coordinator: any FeedCoordinator,
    fetchFeedUseCase: FetchFeedUseCase
  )
}
