//
//  RecordEndpoint.swift
//  RecordsData
//
//  Created by 조용인 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import LocalStorage

import Alamofire

enum RecordEndpoint<T>: APIEndpoint where T: Decodable {
  typealias ResponseType = T
  
  case saveRecord(body: SaveRecordBody)
  case startRecord(body: StartRecordBody)
  case checkRecordStatus(query: CheckRecordStatusQuery)
  case checkCalendarRecords(body: CalendarRecordBody)
  case checkCompletedTotalRecords
}

extension RecordEndpoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String {
    switch self {
    case .saveRecord:
      return "/records/"
    case .startRecord:
      return "/records/start"
    case .checkRecordStatus:
      return "/records/status"
    case .checkCalendarRecords:
      return "/records/calendar"
    case .checkCompletedTotalRecords:
      return "/records/complete/total"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .saveRecord, .startRecord, .checkCalendarRecords, .checkCompletedTotalRecords:
      return .post
    case .checkRecordStatus:
      return .get
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .saveRecord(let body):
      return .requestWithbody(body)
    case .checkCalendarRecords(let body):
      return .requestWithbody(body)
    case .startRecord(let body):
      return .requestWithbody(body)
    case .checkRecordStatus(let query):
      return .requestQuery(query)
    case .checkCompletedTotalRecords:
      return .requestPlain
    }
  }
  
  var headerType: HTTPHeaderType {
    switch self {
    default:
      if let accessToken = KeychainWrapper.shared.accessToken {
        return .authorization(accessToken)
      } else{
        return .plain
      }
    }
  }
}