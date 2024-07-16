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

public enum SampleReactorActionImp: SampleReactorAction {
    /// 구체적인 액션 정의
}

public enum SampleReactorMutationImp: SampleReactorMutation {
    /// 구체적인 뮤테이션 정의
}

public struct SampleReactorStateImp: SampleReactorState {
    /// 구체적인 상태 정의
    public init() {
      
    }
}

public final class SampleReactorImp: SampleReactor {
    public typealias Action = SampleReactorActionImp
    public typealias Mutation = SampleReactorMutationImp
    public typealias State = SampleReactorStateImp

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
