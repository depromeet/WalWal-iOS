//
//  FeedReactor.swift
//
//  Feed
//
//  Created by 이지희
//

import FeedDomain
import FeedCoordinator

import ReactorKit
import RxSwift

public enum FeedReactorAction {
  
}

public enum FeedReactorMutation {
  
}

public struct FeedReactorState {
  public init() {
  
  }
}

public protocol FeedReactor: Reactor where Action == FeedReactorAction, Mutation == FeedReactorMutation, State == FeedReactorState {
  
  var coordinator: any FeedCoordinator { get }
  
  init(
    coordinator: any FeedCoordinator
  )
}
