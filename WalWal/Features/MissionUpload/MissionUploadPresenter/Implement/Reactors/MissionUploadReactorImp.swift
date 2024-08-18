//
//  MissionUploadReactorImp.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import MissionUploadDomain
import MissionUploadPresenter
import MissionUploadCoordinator

import ReactorKit
import RxSwift

public final class MissionUploadReactorImp: SplashReactor {
  public typealias Action = MissionUploadReactorAction
  public typealias Mutation = MissionUploadReactorMutation
  public typealias State = MissionUploadReactorState
  
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
