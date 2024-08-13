//
//  FCMReactor.swift
//
//  FCM
//
//  Created by Jiyeon
//

import FCMDomain
import FCMCoordinator

import ReactorKit
import RxSwift

public enum FCMReactorAction {
  
}

public enum FCMReactorMutation {
  
}

public struct FCMReactorState {
  public init() {
  
  }
}

public protocol FCMReactor: Reactor where Action == FCMReactorAction, Mutation == FCMReactorMutation, State == FCMReactorState {
  
  var coordinator: any __Coordinator { get }
  
  init(
    coordinator: any __Coordinator
  )
}
