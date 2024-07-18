//
//  SplashReactor.swift
//
//  Splash
//
//  Created by 조용인
//

import SplashDomain
import AppCoordinator

import ReactorKit
import RxSwift

public protocol SplashReactorAction {}
public protocol SplashReactorMutation {}
public protocol SplashReactorState {}

public protocol SplashReactor: Reactor where Action: SplashReactorAction, Mutation: SplashReactorMutation, State: SplashReactorState {
  
  var coordinator: any AppCoordinator { get }
  
  init(
    coordinator: any AppCoordinator
  )
}
