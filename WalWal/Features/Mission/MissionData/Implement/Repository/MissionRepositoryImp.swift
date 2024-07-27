//
//  MissionRepositoryImp.swift
//  MissionData
//
//  Created by 이지희 on 7/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import MissionData

import RxSwift

public final class MissionRepositoryImp: MissionRepository {
  
  private let networkService: NetworkServiceProtocol
  
  public init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func getMissionInfo() -> RxSwift.Single<MissionInfoDTO> {
    let endpoint = MissionEndpoint<MissionInfoDTO>.getMissionInfo
    return networkService.request(endpoint: endpoint)
      .compactMap { $0 }
      .asObservable()
      .asSingle()
  }
}
