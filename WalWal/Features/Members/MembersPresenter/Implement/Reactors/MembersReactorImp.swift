//
//  MembersReactorImp.swift
//
//  Members
//
//  Created by Jiyeon
//

import MembersDomain
import MembersPresenter
import MembersCoordinator

import ReactorKit
import RxSwift

public final class MembersReactorImp: SplashReactor {
  public typealias Action = MembersReactorAction
  public typealias Mutation = MembersReactorMutation
  public typealias State = MembersReactorState
  
  public let initialState: State
  public let coordinator: any __Coordinator
  
  public init(
    coordinator: any __Coordinator
  ) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    
  }
}
