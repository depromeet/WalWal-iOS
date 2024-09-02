//
//  FCMReactor.swift
//
//  FCM
//
//  Created by 이지희
//

import FCMDomain
import FCMCoordinator

import ReactorKit
import RxSwift

public enum FCMReactorAction {
  case loadFCMList
}

public enum FCMReactorMutation {
  case loadFCMList
}

public struct FCMReactorState {
  public init() {
  
  }
}

public protocol FCMReactor: Reactor where Action == FCMReactorAction, Mutation == FCMReactorMutation, State == FCMReactorState {
  
  var coordinator: any FCMCoordinator { get }
  
  init(
    coordinator: any FCMCoordinator,
    fcmListUseCase: FCMListUseCase
  )
}
