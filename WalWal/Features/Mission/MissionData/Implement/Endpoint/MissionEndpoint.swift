//
//  MissionEndpoint.swift
//  MissionData
//
//  Created by 이지희 on 7/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork

import Alamofire

enum MissionEndpoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  
  case loadMissionInfo
}

extension MissionEndpoint {
  var baseURLType: WalWalNetwork.URLType {
    return .walWalBaseURL
  }
  
  var path: String {
    switch self {
    case .loadMissionInfo:
      return ""
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .loadMissionInfo:
      return .get
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .loadMissionInfo:
      return .requestPlain
    }
  }
  
  var headers: WalWalNetwork.WalWalHTTPHeader {
    switch self {
    case .loadMissionInfo:
      return.plain
    }
  }
}
