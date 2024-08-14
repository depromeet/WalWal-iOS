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
}

extension FCMEndPoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String{
    switch self {
    case .saveToken:
      return "/alarm/token"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .saveToken:
      return .post
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .saveToken(body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .saveToken:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
    }
  }
  
}
