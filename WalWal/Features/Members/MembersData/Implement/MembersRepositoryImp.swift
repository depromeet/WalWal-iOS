//
//  MembersRepositoryImp.swift
//  MembersDataImp
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import MembersData
import LocalStorage

import RxSwift

public final class MembersRepositoryImp: MembersRepository {
  
  private let networkService: NetworkServiceProtocol
  
  public init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func profileInfo() -> Single<MemberDTO> {
    let endpoint = MembersEndPoint<MemberDTO>.myInfo
    return networkService.request(endpoint: endpoint, isNeedInterceptor: true)
      .compactMap { $0 }
      .asObservable()
      .asSingle()
  }
  
  public func checkValidNickname(nickname: String) -> Single<Void> {
    let isTemporaryUser: Bool = KeychainWrapper.shared.accessToken == nil
    let body = NicknameCheckBody(nickname: nickname)
    let endpoint = MembersEndPoint<EmptyResponse>.checkNickname(body: body)
    return networkService.request(
      endpoint: endpoint,
      isNeedInterceptor: !isTemporaryUser)
    .map { _ in return () }
  }
}
