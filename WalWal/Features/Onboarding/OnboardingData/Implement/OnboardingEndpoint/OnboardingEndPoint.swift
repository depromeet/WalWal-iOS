//
//  OnboardingEndPoint.swift
//  OnboardingData
//
//  Created by Jiyeon on 8/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork

import Alamofire

enum OnboardingEndPoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
}

extension OnboardingEndPoint {
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
