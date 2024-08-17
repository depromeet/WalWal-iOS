//
//  OnboardingRepositoryImp.swift
//  OnboardingData
//
//  Created by Jiyeon on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import OnboardingData

import RxSwift

public final class OnboardingRepositoryImp: OnboardingRepository {
  private let networkService: NetworkServiceProtocol
  
  public init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func checkValidNickname(nickname: String) -> Single<Void> {
    let body = NicknameCheckBody(nickname: nickname)
    let endpoint = OnboardingEndPoint<EmptyResponse>.checkNickname(body: body)
    return networkService.request(endpoint: endpoint, isNeedInterceptor: false)
      .map { _ in return () }
  }
}
