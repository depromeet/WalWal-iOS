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
  
}

public enum RecordDetailReactorMutation {
  
}

public struct RecordDetailReactorState {
  public init() {
  
  }
}

public protocol RecordDetailReactor: Reactor where Action == RecordDetailReactorAction,
                                                   Mutation == RecordDetailReactorMutation,
                                                   State == RecordDetailReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator
  )
}
