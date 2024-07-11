//
//  AuthEndpoint.swift
//  AuthDataImp
//
//  Created by 조용인 on 7/10/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import Alamofire
import WalWalNetwork

enum AuthEndpoint<ResponseType>: APIEndpoint where ResponseType: Decodable {
  typealias Response = ResponseType
  
  case signUp(body: SignUpBody)
  case signIn(body: SignInBody)
}

extension AuthEndpoint {
  var baseURL: URL {
    return URL(string: "")!
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
  
  var headers: WalWalHTTPHeader {
    switch self {
    case .signIn:
      return [
        "Content-Type": "application/json"
      ]
    case .signUp:
      return [
        // 회원가입에는 Data타입이랑 같이 보내기 위해서 Presigned-Url 머시기 헤더에 dataform관련해서 올라가지 않을까
        "Content-Type": "application/json"
      ]
    }
  }
  
}
