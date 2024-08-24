//
//  RecordRepositoryImp.swift
//  RecordsDataImp
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import WalWalNetwork
import RecordsData

import RxSwift

public final class RecordRepositoryImp: RecordRepository {
  
  private let networkService: NetworkServiceProtocol
  
  public init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func saveRecord(missionId: Int, content: String) -> Single<Void> {
    let body = SaveRecordBody(missionId: missionId, content: content)
    let endPoint = RecordEndpoint<EmptyResponse>.saveRecord(body: body)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .map { _ in return }
  }
  
  public func startRecord(missionId: Int) -> Single<MissionRecordStartDTO> {
    let body = StartRecordBody(missionId: missionId)
    let endPoint = RecordEndpoint<MissionRecordStartDTO>.startRecord(body: body)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .compactMap{ $0 }
      .asObservable()
      .asSingle()
  }
  
  public func checkRecordStatus(missionId: Int) -> Single<MissionRecordStatusDTO> {
    let query = CheckRecordStatusQuery(missionId: missionId)
    let endPoint = RecordEndpoint<MissionRecordStatusDTO>.checkRecordStatus(query: query)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .compactMap{ $0 }
      .asObservable()
      .asSingle()
  }
  
  public func checkCalendarRecords(cursor: String, limit: Int) -> Single<MissionRecordCalendarDTO> {
    let query = CalendarRecordQuery(cursor: cursor, limit: limit)
    let endPoint = RecordEndpoint<MissionRecordCalendarDTO>.checkCalendarRecords(query: query)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .compactMap{ $0 }
      .asObservable()
      .asSingle()
  }
  
  public func checkCompletedTotalRecords() -> Single<MissionRecordTotalCountDTO> {
    let endPoint = RecordEndpoint<MissionRecordTotalCountDTO>.checkCompletedTotalRecords
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .compactMap{ $0 }
      .asObservable()
      .asSingle()
  }
  
}
