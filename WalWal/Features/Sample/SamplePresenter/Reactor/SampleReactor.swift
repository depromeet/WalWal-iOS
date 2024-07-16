//
//  SampleReactor.swift
//
//  Sample
//
//  Created by 조용인
//

import UIKit
import SampleAuthCoordinator
import SampleDomain

import ReactorKit
import RxSwift

public class SampleReactor: Reactor {
  public enum Action {
    
  }
  
  public enum Mutation {
    
  }
  
  public struct State {
    
  }
  
  public let initialState: State
  
  private let coordinator: any SampleAuthCoordinator
  private let sampleSignInUsecase: SampleSignInUseCase
  private let sampleSignUpUsecase: SampleSignUpUseCase
  
  public init(
    coordinator: any SampleAuthCoordinator,
    sampleSignInUsecase: SampleSignInUseCase,
    sampleSignUpUsecase: SampleSignUpUseCase
  ) {
    self.coordinator = coordinator
    self.sampleSignInUsecase = sampleSignInUsecase
    self.sampleSignUpUsecase = sampleSignUpUsecase
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
      
    }
    return newState
  }
}

