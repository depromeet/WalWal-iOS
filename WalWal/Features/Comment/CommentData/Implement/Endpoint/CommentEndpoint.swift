//
//  CommentEndpoint.swift
//  CommentData
//
//  Created by 조용인 on 10/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import LocalStorage

import Alamofire

enum CommentEndpoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  
  case getComments(query: GetCommentsQuery)
  case postComments(body: PostCommentsBody)
}

extension CommentEndpoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String{
    switch self {
    case .getComments:
      return "/comments"
    case .postComments:
      return "/comments"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .getComments:
      return .get
    case .postComments:
      return .post
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .getComments(query):
      return .requestQuery(query)
    case let .postComments(body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .getComments, .postComments:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
      }
    }
  }
}
