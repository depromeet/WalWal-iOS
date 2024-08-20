//
//  MyPageEndPoint.swift
//  MyPageData
//
//  Created by Jiyeon on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import LocalStorage

import Alamofire

enum MyPageEndPoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
}

extension MyPageEndPoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String {
    return ""
  }
  var method: HTTPMethod {
    return .get
  }
  
  var parameters: RequestParams {
    return .requestPlain
  }
  
  var headerType: HTTPHeaderType {
    return .plain
  }
}
