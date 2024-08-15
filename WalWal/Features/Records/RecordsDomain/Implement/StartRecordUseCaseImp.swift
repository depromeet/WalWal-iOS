//
//  StartRecordUseCaseImp.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData
import RecordsDomain
import LocalStorage

import RxSwift

public final class StartRecordUseCaseImp: StartRecordUseCase {
  private let recordRepository: RecordRepository
  
  public init(recordRepository: RecordRepository) {
    self.recordRepository = recordRepository
  }
  
  public func execute(missionId: Int) -> Single<Void> {
    return recordRepository.startRecord(missionId: missionId)
  }
}
