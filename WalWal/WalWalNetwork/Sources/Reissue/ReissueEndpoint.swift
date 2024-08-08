//
//  ReissueService.swift
//  WalWalNetwork
//
//  Created by 이지희 on 8/1/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import Alamofire

enum ReissueEndpoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  
  case reissue(body: RefreshToken)
}

extension ReissueEndpoint {
  var baseURLType: URLType {
    switch self {
    case .reissue:
      return .walWalBaseURL
    }
  }
  
  var path: String {
    switch self {
    case .reissue:
      return "/auth/reissue"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .reissue:
      return .post
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .reissue(body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .reissue:
      return .plain
    }
  }
}
