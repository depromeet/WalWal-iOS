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
  
  public func checkCalendarRecords(cursor: String, limit: Int, memberId: Int?) -> Single<MissionRecordCalendarDTO> {
    let query = CalendarRecordQuery(cursor: cursor, limit: limit, memberId: memberId)
    let endPoint = RecordEndpoint<MissionRecordCalendarDTO>.checkCalendarRecords(query: query)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .compactMap{ $0 }
      .asObservable()
      .asSingle()
  }
  
  public func checkCompletedTotalRecords(memberId: Int?) -> Single<MissionRecordTotalCountDTO> {
    let query = memberId != nil ? CheckCompletedTotalRecordsQuery(memberId: memberId!) : nil
    let endPoint = RecordEndpoint<MissionRecordTotalCountDTO>.checkCompletedTotalRecords(query: query)
    return networkService.request(endpoint: endPoint, isNeedInterceptor: true)
      .compactMap{ $0 }
      .asObservable()
      .asSingle()
  }
 
  public func postBoostCount(recordId: Int, count: Int) -> Single<Void> {
    let body = PostBoostCountBody(count: count)
    let endpoint = RecordEndpoint<EmptyResponse>.postBoostCount(recordId: recordId, body: body)
    
    return networkService.request(endpoint: endpoint, isNeedInterceptor: true)
      .map { _ in Void() }
  }
  
  public func fetchRecordList(missionId: Int) -> Single<CompletedRecordDTO> {
    let query = FetchRecordsQuery(missionId: missionId)
    let endpoint = RecordEndpoint<CompletedRecordDTO>.fetchRecords(query: query)
    
    return networkService.request(endpoint: endpoint, isNeedInterceptor: true)
      .compactMap{ $0 }
      .asObservable()
      .asSingle()
  }
}
