//
//  FeedEndpoint.swift
//  FeedDataImp
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import LocalStorage

import Alamofire

enum FeedEndpoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  case fetchFeed(query: FetchFeedQuery)
  case reports(body: ReportParameter)
  case fetchSingleFeed(Int)
}

extension FeedEndpoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String{
    switch self {
    case .fetchFeed(let query):
      return "/feed/v2"
    case .reports:
      return "/reports/feed"
    case let .fetchSingleFeed(recordId):
      return "/feed/\(recordId)"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .fetchFeed:
      return .get
    case .reports:
      return .post
    case .fetchSingleFeed:
      return .get
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .fetchFeed(query):
      return .requestQuery(query)
    case let .reports(body):
      return .requestWithbody(body)
    case .fetchSingleFeed:
      return .requestPlain
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .fetchFeed, .reports, .fetchSingleFeed:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
    }
  }
  
}
