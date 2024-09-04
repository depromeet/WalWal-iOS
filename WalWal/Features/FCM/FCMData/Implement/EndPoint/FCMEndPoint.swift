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
  case deleteToken
  case list(query: FCMListQuery)
  case read(id: Int)
}

extension FCMEndPoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String{
    switch self {
    case .saveToken, .deleteToken:
      return "/alarm/token"
    case .list:
      return "/alarm"
    case let .read(notificationID):
      return "/alarm/\(notificationID)/read"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .saveToken, .read:
      return .post
    case .deleteToken:
      return .delete
    case .list:
      return .get
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .saveToken(body):
      return .requestWithbody(body)
    case .deleteToken, .read:
      return .requestPlain
    case let .list(query):
      return .requestQuery(query)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .saveToken, .deleteToken, .list, .read:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
    }
  }
  
}
