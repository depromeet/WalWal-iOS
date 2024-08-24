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

import RxSwift

public final class StartRecordUseCaseImp: StartRecordUseCase {
  private let recordRepository: RecordRepository
  
  public init(recordRepository: RecordRepository) {
    self.recordRepository = recordRepository
  }
  
  public func execute(missionId: Int) -> Single<MissionRecordStartModel> {
    return recordRepository.startRecord(missionId: missionId)
      .map { MissionRecordStartModel(dto: $0) }
      .asObservable()
      .asSingle()
  }
}
