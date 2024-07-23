//
//  SampleReactor.swift
//  SamplePresenter
//
//  Created by 조용인 on 7/16/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import SampleDomain
import SamplePresenter
import SampleAppCoordinator

import ReactorKit
import RxSwift

public final class SampleReactorImp: SampleReactor {
    public typealias Action = SampleReactorAction
    public typealias Mutation = SampleReactorMutation
    public typealias State = SampleReactorState

    public let initialState: State
    public let coordinator: any SampleAppCoordinator
    public let sampleSignInUsecase: SampleSignInUseCase
    public let sampleSignUpUsecase: SampleSignUpUseCase
    
    public init(
        coordinator: any SampleAppCoordinator,
        sampleSignInUsecase: SampleSignInUseCase,
        sampleSignUpUsecase: SampleSignUpUseCase
    ) {
        self.coordinator = coordinator
        self.sampleSignInUsecase = sampleSignInUsecase
        self.sampleSignUpUsecase = sampleSignUpUsecase
        self.initialState = State()
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
      
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
    }
}
