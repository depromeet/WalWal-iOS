//
//  AuthEndpoint.swift
//  AuthData
//
//  Created by Jiyeon on 7/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import LocalStorage

import Alamofire

enum AuthEndpoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  case socialLogin(provider: String, body: SocialLoginBody)
  case saveToken(body: FCMTokenBody)
}

extension AuthEndpoint {
  var baseURLType: URLType {
    return .walWalBaseURL
   }
  
  var path: String {
    switch self {
    case let .socialLogin(provider, _):
      return "/auth/social-login/\(provider)"
    case .saveToken:
      return "/alarm/token"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .socialLogin, .saveToken:
      return .post
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .socialLogin(_, body):
      return .requestWithbody(body)
    case let .saveToken(body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .socialLogin:
      return .plain
    case .saveToken:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
      
    }
  }
}
