//
//  RecordDetailReactor.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageDomain
import MyPageCoordinator
import DesignSystem

import FeedDomain
import MembersDomain

import GlobalState

import ReactorKit
import RxSwift

public enum RecordDetailReactorAction {
  case loadFeed(memberId: Int, cursorDate: String?)
  case tapBackButton
  case isHiddenTabBar(Bool)
  case commentTapped(recordId: Int)
}

public enum RecordDetailReactorMutation {
  case fetchUseFeed(memberId: Int, nextCursor: String?, newRecord: [WalWalFeedModel])
  case userFeedReachEnd(newRecord: [WalWalFeedModel])
  case userFeedFetchFailed(errorMessage: String)
  case moveToBack
  case moveToComment(recordId: Int)
}

public struct RecordDetailReactorState {
  public var feedData: [WalWalFeedModel] = []
  @Pulse public var feedErrorMessage: String = ""
  public var nextCursor: String? = nil
  public var feedFetchEnded: Bool = false
  public var memberId: Int
  
  public init(memberId: Int) {
    self.memberId = memberId
  }
}


public protocol RecordDetailReactor: Reactor where Action == RecordDetailReactorAction,
                                                   Mutation == RecordDetailReactorMutation,
                                                   State == RecordDetailReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator,
    fetchUserFeedUseCase: FetchUserFeedUseCase,
    memberId: Int
  )
}
