//
//  FeedRepositoryImp.swift
//
//  Feed
//
//  Created by 이지희 on .
//

import Foundation
import WalWalNetwork
import FeedData

import RxSwift

public final class FeedRepositoryImp: FeedRepository {
  private let networkService: NetworkServiceProtocol
  
  public init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func fetchFeedData(memberId: Int?, cursor: String?, limit: Int) -> Single<FeedDTO> {
    let query = FetchFeedQuery(memberId: memberId, cursor: cursor, limit: limit)
    let endPoint = FeedEndpoint<FeedDTO>.fetchFeed(query: query)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .compactMap{ $0 }
      .asObservable()
      .asSingle()
  }
  
  public func fetchSingleFeed(recordId: Int) -> Single<FeedListDTO> {
    let endPoint = FeedEndpoint<FeedListDTO>.fetchSingleFeed(recordId)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .compactMap { $0 }
      .asObservable()
      .asSingle()
  }
}
