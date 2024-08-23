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
import GlobalState

import ReactorKit
import RxSwift

public enum RecordDetailReactorAction {
  case loadFeed(memberId: Int, cursorDate: String?)
  case tapBackButton
}

public enum RecordDetailReactorMutation {
  case fetchUseFeed(memberId: Int, nextCursor: String?)
  case userFeedReachEnd
  case userFeedFetchFailed(errorMessage: String)
  case moveToBack
}

public struct RecordDetailReactorState {
  public var feedData: [WalWalFeedModel] = []
  @Pulse public var feedErrorMessage: String = ""
  public var nextCursor: String? = nil
  public var feedFetchEnded: Bool = false
  public var memberId: Int = GlobalState.shared.profileInfo.value.memberId
  
  public init() {
  
  }
}


public protocol RecordDetailReactor: Reactor where Action == RecordDetailReactorAction,
                                                   Mutation == RecordDetailReactorMutation,
                                                   State == RecordDetailReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator,
    fetchUserFeedUseCase: FetchUserFeedUseCase
  )
}
