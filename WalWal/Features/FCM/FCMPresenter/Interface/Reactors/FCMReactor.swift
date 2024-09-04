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
  case loadFCMList
  case refreshList
  case selectItem(item: FCMItemModel)
}

public enum FCMReactorMutation {
  case loadFCMList(data: [FCMSectionModel])
  case stopRefreshControl
}

public struct FCMReactorState {
  public init() { }
  public var listData: [FCMSectionModel] = []
  @Pulse public var stopRefreshControl: Bool = false
}

public protocol FCMReactor: Reactor where Action == FCMReactorAction, Mutation == FCMReactorMutation, State == FCMReactorState {
  
  var coordinator: any FCMCoordinator { get }
  
  init(
    coordinator: any FCMCoordinator,
    fetchFCMListUseCase: FetchFCMListUseCase,
    fcmListUseCase: FCMListUseCase,
    readFCMItemUseCase: ReadFCMItemUseCase
  )
}
