//
//  CheckCompletedTotalRecordsUseCase.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol CheckCompletedTotalRecordsUseCase {
  func execute(memberId: Int?) -> Single<MissionRecordTotalCountModel>
}
