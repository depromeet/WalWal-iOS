//
//  FCMEndPoint.swift
//  FCMData
//
//  Created by Jiyeon on 8/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import LocalStorage

import Alamofire

enum FCMEndPoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  case saveToken(body: FCMTokenBody)
  case deleteToken(body: FCMTokenBody)
}

extension FCMEndPoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String{
    switch self {
    case .saveToken, .deleteToken:
      return "/alarm/token"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .saveToken:
      return .post
    case .deleteToken:
      return .delete
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .saveToken(body):
      return .requestWithbody(body)
    case let .deleteToken(body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .saveToken, .deleteToken:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
    }
  }
  
}
