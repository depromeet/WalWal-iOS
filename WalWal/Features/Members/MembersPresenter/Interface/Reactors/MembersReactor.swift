//
//  MembersReactor.swift
//
//  Members
//
//  Created by Jiyeon
//

import MembersDomain
import MembersCoordinator

import ReactorKit
import RxSwift

public enum MembersReactorAction {
  
}

public enum MembersReactorMutation {
  
}

public struct MembersReactorState {
  public init() {
  
  }
}

public protocol MembersReactor: Reactor where Action == MembersReactorAction, Mutation == MembersReactorMutation, State == MembersReactorState {
  
  var coordinator: any __Coordinator { get }
  
  init(
    coordinator: any __Coordinator
  )
}
