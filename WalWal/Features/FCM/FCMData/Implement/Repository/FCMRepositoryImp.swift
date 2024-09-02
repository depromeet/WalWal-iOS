//
//  FCMDataRepositoryImp.swift
//  FCMData
//
//  Created by Jiyeon on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import FCMData

import RxSwift

public final class FCMRepositoryImp: FCMRepository {
  private let networkService: NetworkServiceProtocol
  
  public init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func fcmTokenSave(token: String) -> Single<Void> {
    let body = FCMTokenBody(token: token)
    let endPoint = FCMEndPoint<EmptyResponse>.saveToken(body: body)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .map { _ in Void() }
  }
  
  public func fcmTokenDelete() -> Single<Void> {
    let endPoint = FCMEndPoint<EmptyResponse>.deleteToken
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .map { _ in Void() }
  }
  
  public func fetchFCMList(cursor: String?, limit: Int) -> Single<FCMListDTO> {
    let query = FCMListQuery(cursor: cursor, limit: limit)
    let endpoint = FCMEndPoint<FCMListDTO>.list(query: query)
    return networkService.request(endpoint: endpoint, isNeedInterceptor: true)
      .debug()
      .compactMap { $0 }
      .asObservable()
      .asSingle()
  }
}
