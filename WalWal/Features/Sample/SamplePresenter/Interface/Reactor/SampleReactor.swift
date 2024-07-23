//
//  SampleReactor.swift
//
//  Sample
//
//  Created by 조용인
//
//

import SampleAppCoordinator
import SampleDomain

import ReactorKit
import RxSwift

public enum SampleReactorAction {
  
}
public enum SampleReactorMutation {
  
}
public struct SampleReactorState {
  public init() { }
}

public protocol SampleReactor: Reactor where Action == SampleReactorAction, Mutation == SampleReactorMutation, State == SampleReactorState {
  var coordinator: any SampleAppCoordinator { get }
  var sampleSignInUsecase: SampleSignInUseCase { get }
  var sampleSignUpUsecase: SampleSignUpUseCase { get }
  
  init(
    coordinator: any SampleAppCoordinator,
    sampleSignInUsecase: SampleSignInUseCase,
    sampleSignUpUsecase: SampleSignUpUseCase
  )
}
