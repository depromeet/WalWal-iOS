//
//  MyPageReactor.swift
//
//  MyPage
//
//  Created by 조용인
//

import MyPageDomain
import MyPageCoordinator

import ReactorKit
import RxSwift

public enum MyPageReactorAction {
  
}

public enum MyPageReactorMutation {
  
}

public struct MyPageReactorState {
  public init() {
  
  }
}

public protocol MyPageReactor: Reactor where Action == MyPageReactorAction, Mutation == MyPageReactorMutation, State == MyPageReactorState {
  
  var coordinator: any __Coordinator { get }
  
  init(
    coordinator: any __Coordinator
  )
}
