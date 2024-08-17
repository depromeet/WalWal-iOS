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
  case checkNickname(body: NicknameCheckBody)
}

extension OnboardingEndPoint {
  var baseURLType: URLType {
    switch self {
    case .checkNickname:
      return .walWalBaseURL
    }
  }
  
  var path: String {
    switch self {
    case .checkNickname:
      return "/members/check-nickname"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .checkNickname:
      return .post
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .checkNickname(body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .checkNickname:
      return .authorization(
        UserDefaults.string(forUserDefaultsKey: .temporaryToken)
      )
    }
  }
}
