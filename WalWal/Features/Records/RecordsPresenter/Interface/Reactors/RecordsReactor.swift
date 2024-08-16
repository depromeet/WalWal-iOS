//
//  RecordsReactor.swift
//
//  Records
//
//  Created by 조용인
//

import RecordsDomain
import RecordsCoordinator

import ReactorKit
import RxSwift

public enum RecordsReactorAction {
  
}

public enum RecordsReactorMutation {
  
}

public struct RecordsReactorState {
  public init() {
  
  }
}

public protocol RecordsReactor: Reactor where Action == RecordsReactorAction, Mutation == RecordsReactorMutation, State == RecordsReactorState {
  
  var coordinator: any __Coordinator { get }
  
  init(
    coordinator: any __Coordinator
  )
}
