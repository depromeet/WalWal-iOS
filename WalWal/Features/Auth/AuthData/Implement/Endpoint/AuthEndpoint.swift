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
import AuthData

import Alamofire

enum AuthEndpoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  case socialLogin(provider: String, body: SocialLoginBody)
  case register(body: RegisterBody)
  case withdraw
}

extension AuthEndpoint {
  var baseURLType: URLType {
    return .walWalBaseURL
   }
  
  var path: String {
    switch self {
    case let .socialLogin(provider, _):
      return "/auth/social-login/\(provider)"
    case .register:
      return "/auth/register"
    case .withdraw:
      return "/auth/withdraw"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .socialLogin, .register:
      return .post
    case .withdraw:
      return .delete
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .socialLogin(_, body):
      return .requestWithbody(body)
    case let .register(body):
      return .requestWithbody(body)
    case .withdraw:
      return .requestPlain
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .socialLogin:
      return .plain
    case .register:
      return .authorization(UserDefaults.string(forUserDefaultsKey: .temporaryToken))
    case .withdraw:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
    }
  }
}
