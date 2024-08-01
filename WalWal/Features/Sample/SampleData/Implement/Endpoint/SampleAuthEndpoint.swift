//
//  SampleAuthEndpoint.swift
//  SampleData
//
//  Created by 조용인 on 7/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork

import Alamofire

enum AuthEndpoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  
  case signUp(body: SampleSignUpBody)
  case signIn(body: SampleSignInBody)
}

extension AuthEndpoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String {
    switch self {
    case .signIn:
      return "/signIn"
    case .signUp:
      return "/signUp"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .signIn:
      return .post
    case .signUp:
      return .post
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .signIn(let body):
      return .requestWithbody(body)
    case .signUp(let body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .signIn:
        .plain
    case .signUp:
        .plain
    }
  }
}
