//
//  RecordsDependencyFactoryInterface.swift
//
//  Records
//
//  Created by 조용인
//

import UIKit

import RecordsDomain
import RecordsData

public protocol RecordsDependencyFactory {
  func injectRecordsRepository() -> RecordRepository
  func injectCheckCalendarRecordsUseCase() -> CheckCalendarRecordsUseCase
  func injectCheckCompletedTotalRecordsUseCase() -> CheckCompletedTotalRecordsUseCase
  func injectCheckRecordStatusUseCase() -> CheckRecordStatusUseCase
  func injectRemoveGlobalCalendarRecordsUseCase() -> RemoveGlobalCalendarRecordsUseCase
  func injectSaveRecordUseCase() -> SaveRecordUseCase
  func injectStartRecordUseCase() -> StartRecordUseCase
  func injectUpdateRecordUseCase() -> UpdateBoostCountUseCase
}
