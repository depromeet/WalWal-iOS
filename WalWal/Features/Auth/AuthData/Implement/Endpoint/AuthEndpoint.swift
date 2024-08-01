//
//  AuthEndpoint.swift
//  AuthData
//
//  Created by Jiyeon on 7/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork

import Alamofire

enum AuthEndpoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  case socialLogin(provider: String, body: SocialLoginBody)
  case appleLogin(body: SocialLoginBody)
}

extension AuthEndpoint {
  var baseURLType: URLType {
     switch self {
     case .appleLogin(_):
       return .walWalBaseURL
     }
   }
  
  var path: String {
    switch self {
    case let .socialLogin(provider, _):
      return "/auth/social-login/\(provider)"
    case .appleLogin:
      return "/auth/social-login/apple"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .socialLogin, .appleLogin:
      return .post
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .socialLogin(_, body):
      return .requestWithbody(body)
    case let .appleLogin(body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .socialLogin, .appleLogin:
      return .plain
    }
  }
}
