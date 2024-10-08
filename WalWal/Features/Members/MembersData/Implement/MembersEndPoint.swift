//
//  MembersEndPoint.swift
//  MembersDataImp
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import LocalStorage

import Alamofire

enum MembersEndPoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  
  case memberInfo(memberId: Int)
  case myInfo
  case checkNickname(body: NicknameCheckBody)
  case editProfile(body: EditProfileBody)
}

extension MembersEndPoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String {
    switch self {
    case .myInfo, .editProfile:
      return "/members/me"
    case .checkNickname:
      return "/members/check-nickname"
    case let .memberInfo(memberId):
      return "/members/\(memberId)"
    }
  }
  var method: HTTPMethod {
    switch self {
    case .myInfo:
      return .get
    case .checkNickname:
      return .post
    case .editProfile:
      return .put
    case .memberInfo:
      return .get
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .myInfo, .memberInfo:
      return .requestPlain
    case let .checkNickname(body):
      return .requestWithbody(body)
    case let .editProfile(body):
      return .requestWithbody(body)
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    case .myInfo, .editProfile, .memberInfo:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
    case .checkNickname:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .authorization(
          UserDefaults.string(forUserDefaultsKey: .temporaryToken)
        )
      }
    }
  }
}
