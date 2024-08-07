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
  case requestPresignedUrl(body: PresignedURLBody)
  case uploadImage(url: String)
  case uploadComplete(body: UploadCompleteBody)
}

extension OnboardingEndPoint {
  var baseURLType: URLType {
    switch self {
    case .checkNickname, .requestPresignedUrl, .uploadComplete:
      return .walWalBaseURL
    case let .uploadImage(url):
      return .presignedURL(url)
    }
  }
  
  var path: String {
    switch self {
    case .checkNickname:
      return "/memebers/check-nickname"
    case .requestPresignedUrl:
      return "/images/members/me/upload-url"
    case .uploadImage:
      return ""
    case .uploadComplete:
      return "/images/members/me/upload-complete"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .checkNickname, .requestPresignedUrl, .uploadComplete:
      return .post
    case .uploadImage:
      return .put
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case let .checkNickname(body):
      return .requestWithbody(body)
    case let .requestPresignedUrl(body):
      return .requestWithbody(body)
    case .uploadImage:
      return .upload
    case let .uploadComplete(body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .checkNickname, .requestPresignedUrl, .uploadComplete:
      return .authorization(
        UserDefaults.string(forUserDefaultsKey: .temporaryToken)
      )
    case .uploadImage:
      return .plain
    }
  }
}
