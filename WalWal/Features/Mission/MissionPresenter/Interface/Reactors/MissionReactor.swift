//
//  MissionReactor.swift
//
//  Mission
//
//  Created by 이지희
//

import MissionDomain
import MissionCoordinator

import ReactorKit
import RxSwift

public enum MissionReactorAction {

}

public enum MissionReactorMutation {

}

public enum MissionReactorState {
  public init() {
  
  }
}

public protocol MissionReactor: Reactor where Action: MissionReactorAction, Mutation: MissionReactorMutation, State: MissionReactorState {
  
  var coordinator: any MissionCoordinator { get }
  
  init(
    coordinator: any MissionCoordinator
  )
}
