//
//  AuthReactor.swift
//
//  Auth
//
//  Created by Jiyeon
//

import AuthDomain
import AuthCoordinator
import FCMDomain
import RecordsDomain

import ReactorKit
import RxSwift

public enum AuthReactorAction {
  case appleLoginTapped(authCode: String)
  case kakaoLoginTapped
}

public enum AuthReactorMutation {
  case loginErrorMsg(msg: String)
  case showIndicator(show: Bool)
}

public struct AuthReactorState {
  /// 구체적인 상태 정의
  public init() { }
  @Pulse public var message: String = ""
  public var showIndicator: Bool = false
}

public protocol AuthReactor:
  Reactor where Action == AuthReactorAction,
                  Mutation == AuthReactorMutation,
                  State == AuthReactorState {
  var coordinator: any AuthCoordinator { get }
  
  init(
    coordinator: any AuthCoordinator,
    socialLoginUseCase: SocialLoginUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    userTokensSaveUseCase: UserTokensSaveUseCase,
    kakaoLoginUseCase: KakaoLoginUseCase,
    checkRecordCalendarUseCase: CheckCalendarRecordsUseCase,
    removeGlobalCalendarRecordsUseCase: RemoveGlobalCalendarRecordsUseCase
  )
}
