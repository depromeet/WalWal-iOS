//
//  FCMReactor.swift
//
//  FCM
//
//  Created by 이지희
//

import Foundation
import FCMDomain
import FCMCoordinator

import ReactorKit
import RxSwift

public enum FCMReactorAction {
  case loadFCMList(cursor: String?, limit: Int = 10)
  case refreshList
  case selectItem(item: FCMItemModel)
  case updateItem(index: IndexPath)
  case doubleTap(Int?)
}

public enum FCMReactorMutation {
  case loadFCMList(data: [FCMSection])
  case stopRefreshControl
  case moveMission
  case moveFeed
  case updateItem(index: IndexPath)
  case nextCursor(cursor: String?)
  case isLastPage(Bool)
  case isHiddenEdgePage(Bool)
  case scrollToTop(Bool)
  case resetTabEvent
}

public struct FCMReactorState {
  public init() { }
  @Pulse public var listData: [FCMSection] = []
  @Pulse public var stopRefreshControl: Bool = false
  public var nextCursor: String? = nil
  public var isLastPage: Bool = false
  public var isHiddenEdgePage: Bool = true
  public var isDoubleTap: Bool = false
}

public protocol FCMReactor: Reactor where Action == FCMReactorAction, Mutation == FCMReactorMutation, State == FCMReactorState {
  
  var coordinator: any FCMCoordinator { get }
  
  init(
    coordinator: any FCMCoordinator,
    fetchFCMListUseCase: FetchFCMListUseCase,
    fcmListUseCase: FCMListUseCase,
    readFCMItemUseCase: ReadFCMItemUseCase,
    saveFeedRecordIDUseCase: SaveFeedRecordIDUseCase,
    removeGlobalFCMListUseCase: RemoveGlobalFCMListUseCase,
    saveFCMListGlobalStateUseCase: SaveFCMListGlobalStateUseCase
  )
}
