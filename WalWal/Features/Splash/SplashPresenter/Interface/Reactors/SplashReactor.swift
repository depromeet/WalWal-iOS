//
//  SplashReactor.swift
//
//  Splash
//
//  Created by 조용인
//

import Foundation
import SplashDomain
import FCMDomain
import RecordsDomain
import MembersDomain
import AppCoordinator

import ReactorKit
import RxSwift

public enum SplashReactorAction {
  case checkToken
  case moveUpdate
}

public enum SplashReactorMutation {
  case startAuth
  case startMain
  case openAppStore(url: URL)
}

public struct SplashReactorState {
  public var url: URL? = nil
  public init() {}
}

public protocol SplashReactor:
  Reactor where Action == SplashReactorAction,
                Mutation == SplashReactorMutation,
                  State == SplashReactorState {
  
  var coordinator: any AppCoordinator { get }
  
  init(
    coordinator: any AppCoordinator,
    checkTokenUseCase: CheckTokenUsecase,
    checkIsFirstLoadedUseCase: CheckIsFirstLoadedUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    memberInfoUseCase: MemberInfoUseCase
  )
}
