//
//  AuthReactor.swift
//
//  Auth
//
//  Created by Jiyeon
//

import AuthDomain
import AuthCoordinator

import ReactorKit
import RxSwift

public protocol AuthReactorAction {}
public protocol AuthReactorMutation {}
public protocol AuthReactorState {}

public protocol AuthReactor: Reactor where Action: AuthReactorAction, Mutation: AuthReactorMutation, State: AuthReactorState {
  var coordinator: any AuthCoordinator { get }
  
  init(
    coordinator: any AuthCoordinator
  )
}
