//
//  SplashReactorImp.swift
//
//  Splash
//
//  Created by 조용인
//

import SplashDomain
import SplashPresenter
import SplashCoordinator

import ReactorKit
import RxSwift

public final class SplashReactorImp: SplashReactor {
    public typealias Action = SplashReactorAction
    public typealias Mutation = SplashReactorMutation
    public typealias State = SplashReactorState

    public let initialState: State
    public let coordinator: any SplashCoordinator
    
    public init(
        coordinator: any SplashCoordinator
    ) {
        self.coordinator = coordinator
        self.initialState = State()
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
      
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
