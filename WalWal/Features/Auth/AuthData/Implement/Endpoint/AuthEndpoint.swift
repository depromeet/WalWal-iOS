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
  
  case appleLogin(body: AppleLoginBody)
}

extension AuthEndpoint {
  var path: String {
    switch self {
    case .appleLogin:
      return "/auth/social-login/apple"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .appleLogin:
      return .post
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .appleLogin(body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .appleLogin:
      return .plain
    }
  }
}
