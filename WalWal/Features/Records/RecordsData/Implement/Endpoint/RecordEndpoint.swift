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
  case checkCalendarRecords(query: CalendarRecordQuery)
  case checkCompletedTotalRecords(query: CheckCompletedTotalRecordsQuery?)
}

extension RecordEndpoint {
  var baseURLType: URLType {
    return .walWalBaseURL
  }
  
  var path: String {
    switch self {
    case .saveRecord:
      return "/records"
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
    case .saveRecord, .startRecord:
      return .post
    case .checkRecordStatus, .checkCalendarRecords, .checkCompletedTotalRecords:
      return .get
    }
  }
  
  var parameters: RequestParams {
    switch self {
    case .saveRecord(let body):
      return .requestWithbody(body)
    case .checkCalendarRecords(let query):
      return .requestQuery(query)
    case .startRecord(let body):
      return .requestWithbody(body)
    case .checkRecordStatus(let query):
      return .requestQuery(query)
    case .checkCompletedTotalRecords(let query):
      if query != nil {
        return .requestQuery(query)
      }
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
