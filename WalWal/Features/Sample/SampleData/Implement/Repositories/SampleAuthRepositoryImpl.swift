//
//  SampleAuthRepositoryImpl.swift
//  SampleDataImp
//
//  Created by 조용인 on 7/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import WalWalNetwork
import SampleData

import RxSwift

public final class AuthDataRepositoryImpl: AuthDataRepository {
  
  // MARK: - Properties

  private let networkService: NetworkServiceProtocol
  
  // MARK: - Initializers
  
  public init(
    networkService: NetworkServiceProtocol
  ) {
    self.networkService = networkService
  }
  
  // MARK: - Methods
  
  // - Interface에 정의된 함수를 구현해주세요.
  public func signUp(nickname: String, profile: Data) -> Single<SignUpDTO> {
    let body = SignUpBody(nickname: nickname, profile: profile)
    let endpoint = AuthEndpoint<SignUpDTO>.signUp(body: body)
    return networkService.request(endpoint: endpoint).compactMap{ $0 }.asObservable().asSingle()
  }
  
  public func signIn(id: String, password: String) -> Single<SignInDTO> {
    let body = SignInBody(id: id, password: password)
    let endpoint = AuthEndpoint<SignInDTO>.signIn(body: body)
    return networkService.request(endpoint: endpoint).compactMap{ $0 }.asObservable().asSingle()
  }
}
