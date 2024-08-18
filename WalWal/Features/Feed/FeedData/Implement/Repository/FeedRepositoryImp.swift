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
  
  public func fetchFeedData(cursor: String, limit: Int) -> Single<FeedDTO> {
    let query = FetchFeedQuery(cursor: cursor, limit: limit)
    let endPoint = FeedEndpoint<FeedDTO>.fetchFeed(query: query)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .compactMap{ $0 }
      .asObservable()
      .asSingle()
  }
}
