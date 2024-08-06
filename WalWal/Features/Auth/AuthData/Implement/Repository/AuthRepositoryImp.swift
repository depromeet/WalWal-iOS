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
    return networkService.request(endpoint: endPoint)
      .compactMap{ $0 }
      .asObservable()
      .asSingle()
  }
}
