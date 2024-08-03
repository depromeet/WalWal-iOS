//
//  RecordDetailReactor.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageDomain
import MyPageCoordinator

import ReactorKit
import RxSwift

public enum RecordDetailReactorAction {
  case fetchFeed
}

public enum RecordDetailReactorMutation {
  case setFeedData([RecordModel])
}

public struct RecordDetailReactorState {
  var feedData: [RecordModel] = []
}


public protocol RecordDetailReactor: Reactor where Action == RecordDetailReactorAction,
                                                   Mutation == RecordDetailReactorMutation,
                                                   State == RecordDetailReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator
  )
}
