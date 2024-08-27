//
//  RecordsDependencyFactoryImplement.swift
//
//  Records
//
//  Created by 조용인
//

import UIKit
import RecordsDependencyFactory

import WalWalNetwork

import RecordsData
import RecordsDataImp
import RecordsDomain
import RecordsDomainImp

public class RecordsDependencyFactoryImp: RecordsDependencyFactory {
  
  public init() {
    
  }
  
  public func injectRecordsRepository() -> any RecordRepository {
    let networkService = NetworkService()
    return RecordRepositoryImp(networkService: networkService)
  }
  
  public func injectCheckCalendarRecordsUseCase() -> any CheckCalendarRecordsUseCase {
    return CheckCalendarRecordsUseCaseImp(recordRepository: injectRecordsRepository())
  }
  
  public func injectCheckCompletedTotalRecordsUseCase() -> any CheckCompletedTotalRecordsUseCase {
    return CheckCompletedTotalRecordsUseCaseImp(recordRepository: injectRecordsRepository())
  }
  
  public func injectCheckRecordStatusUseCase() -> any CheckRecordStatusUseCase {
    return CheckRecordStatusUseCaseImp(recordRepository: injectRecordsRepository())
  }
  
  public func injectRemoveGlobalCalendarRecordsUseCase() -> any RemoveGlobalCalendarRecordsUseCase {
    return RemoveGlobalCalendarRecordsUseCaseImp()
  }
  
  public func injectSaveRecordUseCase() -> any SaveRecordUseCase {
    return SaveRecordUseCaseImp(recordRepository: injectRecordsRepository())
  }
  
  public func injectStartRecordUseCase() -> any StartRecordUseCase {
    return StartRecordUseCaseImp(recordRepository: injectRecordsRepository())
  }
  
  public func injectUpdateRecordUseCase() -> any UpdateBoostCountUseCase {
    return UpdateBoostCountUseCaseImp(recordRepository: injectRecordsRepository())
  }
}
