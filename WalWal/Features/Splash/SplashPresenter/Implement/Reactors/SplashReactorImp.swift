//
//  SplashReactorImp.swift
//
//  Splash
//
//  Created by 조용인
//

import SplashDomain
import SplashPresenter
import AppCoordinator

import ReactorKit
import RxSwift

public enum SplashReactorActionImp: SplashReactorAction {

}

public enum SplashReactorMutationImp: SplashReactorMutation {

}

public struct SplashReactorStateImp: SplashReactorState {
  public init() {
  
  }
}

public final class SplashReactorImp: SplashReactor {
    public typealias Action = SplashReactorActionImp
    public typealias Mutation = SplashReactorMutationImp
    public typealias State = SplashReactorStateImp

    public let initialState: State
    public let coordinator: any AppCoordinator
    
    public init(
        coordinator: any AppCoordinator
    ) {
        self.coordinator = coordinator
        self.initialState = State()
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
      
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
