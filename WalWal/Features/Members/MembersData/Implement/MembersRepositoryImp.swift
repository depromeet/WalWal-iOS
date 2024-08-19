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
}
