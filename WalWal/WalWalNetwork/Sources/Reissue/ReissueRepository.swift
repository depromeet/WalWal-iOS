//
//  ReissueRepository.swift
//  WalWalNetwork
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

final class ReissueRepository {
  
  private let networkService: NetworkServiceProtocol
  
  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }

  func reissue(refreshToken: String) -> Single<ReissueResponseDTO> {
    let body = ReissueRequestDTO(refreshToken: refreshToken)
    let endpoint = ReissueEndpoint<ReissueResponseDTO>.reissue(body: body)
    return networkService.request(endpoint: endpoint)
      .compactMap { $0 }
      .asObservable()
      .asSingle()
  }
}
