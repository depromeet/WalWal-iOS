//
//  SaveRecordUseCaseImp.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import RecordsData
import RecordsDomain

import RxSwift

public final class SaveRecordUseCaseImp: SaveRecordUseCase {
  private let recordRepository: RecordRepository
  
  public init(recordRepository: RecordRepository) {
    self.recordRepository = recordRepository
  }
  
  public func execute(missionId: Int, content: String) -> Single<Void> {
    return recordRepository.saveRecord(missionId: missionId, content: content)
  }
}
