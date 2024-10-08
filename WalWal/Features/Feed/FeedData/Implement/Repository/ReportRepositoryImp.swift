//
//  ReportRepositoryImp.swift
//  FeedDataImp
//
//  Created by Jiyeon on 10/5/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import FeedData

import RxSwift

public final class ReportRepositoryImp: ReportRepository {
  
  private let networkService: NetworkService
  
  public init(networkService: NetworkService) {
    self.networkService = networkService
  }
  
  public func reportRequest(recordId: Int, type: String, details: String?) -> Single<Void> {
    let body = ReportParameter(recordId: recordId, reason: type, details: details)
    let endpoint = FeedEndpoint<EmptyResponse>.reports(body: body)
    return networkService.request(endpoint: endpoint)
      .map { _ in Void() }
  }
}
