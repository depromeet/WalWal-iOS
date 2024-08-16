//
//  CheckRecordStatusUseCaseImp.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData
import RecordsDomain

import RxSwift

public final class CheckRecordStatusUseCaseImp: CheckRecordStatusUseCase {
  private let recordRepository: RecordRepository
  
  public init(recordRepository: RecordRepository) {
    self.recordRepository = recordRepository
  }
  
  public func execute(missionId: Int) -> Single<MissionRecordStatusModel> {
    return recordRepository.checkRecordStatus(missionId: missionId)
      .map{ MissionRecordStatusModel(dto: $0) }
      .asObservable()
      .asSingle()
  }
}
