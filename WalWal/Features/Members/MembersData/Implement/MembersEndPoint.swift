//
//  MembersEndPoint.swift
//  MembersDataImp
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import LocalStorage

import Alamofire

enum MembersEndPoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  case myInfo
}

extension MembersEndPoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String {
    switch self {
    case .myInfo:
      return "/members/me"
    }
  }
  var method: HTTPMethod {
    switch self {
    case .myInfo:
      return .get
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .myInfo:
      return .requestPlain
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .myInfo:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
    }
  }
}
