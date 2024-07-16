//
//  SampleReactor.swift
//
//  Sample
//
//  Created by 조용인
//
//

import ReactorKit
import RxSwift
import SampleAuthCoordinator
import SampleDomain

public protocol SampleReactorAction {}
public protocol SampleReactorMutation {}
public protocol SampleReactorState {}

public protocol SampleReactor: Reactor where Action: SampleReactorAction, Mutation: SampleReactorMutation, State: SampleReactorState {
  var coordinator: any SampleAuthCoordinator { get }
  var sampleSignInUsecase: SampleSignInUseCase { get }
  var sampleSignUpUsecase: SampleSignUpUseCase { get }
  
  init(
    coordinator: any SampleAuthCoordinator,
    sampleSignInUsecase: SampleSignInUseCase,
    sampleSignUpUsecase: SampleSignUpUseCase
  )
}
