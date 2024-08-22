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
}

extension FeedEndpoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String{
    switch self {
    case .fetchFeed(let query):
      return "/feed"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .fetchFeed:
      return .get
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .fetchFeed(query):
        return .requestQuery(query)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .fetchFeed:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
    }
  }
  
}
