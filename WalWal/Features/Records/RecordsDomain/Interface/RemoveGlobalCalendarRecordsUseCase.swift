//
//  RemoveGlobalCalendarRecordsUseCase.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol RemoveGlobalCalendarRecordsUseCase {
  func execute() -> Single<Void>
}
