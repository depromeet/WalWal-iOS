//
//  SaveRecordUseCase.swift
//  RecordsDomain
//
//  Created by 조용인 on 8/15/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol SaveRecordUseCase {
  func execute(missionId: Int, content: String) -> Single<Void>
}
