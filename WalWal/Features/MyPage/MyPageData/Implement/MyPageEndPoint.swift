//
//  MyPageEndPoint.swift
//  MyPageData
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import LocalStorage

import Alamofire

enum MyPageEndPoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  case withdraw
}

extension MyPageEndPoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String {
    switch self {
    case .withdraw:
      return "/auth/withdraw"
    }
  }
  var method: HTTPMethod {
    switch self {
    case .withdraw:
      return .delete
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .withdraw:
      return .requestPlain
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .withdraw:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
    }
  }
}
