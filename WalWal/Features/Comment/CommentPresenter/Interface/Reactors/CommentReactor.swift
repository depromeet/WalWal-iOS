//
//  CommentReactor.swift
//
//  Comment
//
//  Created by 조용인
//

import CommentDomain
import CommentCoordinator

import ReactorKit
import RxSwift

public enum CommentReactorAction {
  
}

public enum CommentReactorMutation {
  
}

public struct CommentReactorState {
  public init() {
  
  }
}

public protocol CommentReactor: Reactor where Action == CommentReactorAction, Mutation == CommentReactorMutation, State == CommentReactorState {
  
  var coordinator: any __Coordinator { get }
  
  init(
    coordinator: any __Coordinator
  )
}
