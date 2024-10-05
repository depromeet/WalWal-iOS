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
}

extension FeedEndpoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String{
    switch self {
    case .fetchFeed(let query):
      return "/feed"
    case .reports:
      return "/reports"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .fetchFeed:
      return .get
    case .reports:
      return .post
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .fetchFeed(query):
      return .requestQuery(query)
    case let .reports(body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .fetchFeed, .reports:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
    }
  }
  
}
