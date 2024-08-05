//
//  AuthReactorImp.swift
//
//  Auth
//
//  Created by Jiyeon
//

import Foundation
import AuthDomain
import AuthPresenter
import AuthCoordinator
import LocalStorage

import ReactorKit
import RxSwift

public final class AuthReactorImp: AuthReactor {
  public typealias Action = AuthReactorAction
  public typealias Mutation = AuthReactorMutation
  public typealias State = AuthReactorState
  
  public let initialState: State
  public let coordinator: any AuthCoordinator
  private let socialLoginUseCase: SocialLoginUseCase
  
  public init(
    coordinator: any AuthCoordinator,
    socialLoginUseCase: SocialLoginUseCase
  ) {
    self.coordinator = coordinator
    self.initialState = State()
    self.socialLoginUseCase = socialLoginUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .appleLoginTapped(authCode):
      return .concat([
        .just(.showIndicator(show: true)),
        socialLoginRequest(provider: .apple, token: authCode)
      ])
    case let .kakaoLoginTapped(accessToken):
      return .concat([
        .just(.showIndicator(show: true)),
        socialLoginRequest(provider: .kakao, token: accessToken)
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = State()
    switch mutation {
    case let .loginErrorMsg(msg):
      newState.message = msg
    case let .showIndicator(show):
      newState.showIndicator = show
    }
    return newState
  }
}

extension AuthReactorImp {
  private func socialLoginRequest(provider: ProviderType, token: String) -> Observable<Mutation> {
    return socialLoginUseCase.excute(provider: provider, token: token)
      .asObservable()
      .flatMap { result -> Observable<Mutation> in
        UserDefaults.setValue(value: result.refreshToken, forUserDefaultKey: .refreshToken)
        let _ = KeychainWrapper.shared.setAccessToken(result.accessToken)
        if result.isTemporaryToken {
          self.coordinator.startOnboarding()
        } else {
          self.coordinator.startMission()
        }
        return .just(.showIndicator(show: false))
      }
      .catch { error -> Observable<Mutation> in
        return .concat([
          .just(.showIndicator(show: false)),
          .just(.loginErrorMsg(msg: "로그인에 실패하였습니다"))
        ])
      }
  }
}
