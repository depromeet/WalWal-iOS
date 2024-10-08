//
//  AuthDataRepositoryImpl.swift
//  AuthData
//
//  Created by Jiyeon on 7/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import AuthData

import RxSwift

public final class AuthRepositoryImp: AuthRepository {
  
  private let networkService: NetworkServiceProtocol
  
  public init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func socialLogin(provider: String, token: String) -> Single<AuthTokenDTO> {
    let body = SocialLoginBody(token: token)
    let endPoint = AuthEndpoint<AuthTokenDTO>.socialLogin(provider: provider, body: body)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: false)
      .compactMap{ $0 }
      .asObservable()
      .asSingle()
  }
  
  public func register(
    nickname: String,
    petType: String,
    defaultProfile: String?
  ) -> Single<AuthTokenDTO> {
    let body = RegisterBody(
      nickname: nickname,
      raisePet: petType,
      profileImageUrl: defaultProfile
    )
    let endPoint = AuthEndpoint<AuthTokenDTO>.register(body: body)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: false)
      .compactMap { $0 }
      .asObservable()
      .asSingle()
  }
  
  public func withdraw() -> Single<Void> {
    let endpoint = AuthEndpoint<EmptyResponse>.withdraw
    return networkService.request(endpoint: endpoint, isNeedInterceptor: true)
      .map { _ in Void() }
  }
}
