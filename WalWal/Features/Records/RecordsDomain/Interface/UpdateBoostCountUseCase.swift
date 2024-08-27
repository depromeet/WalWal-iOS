//
//  UpdateBoostCountUseCase.swift
//  RecordsDomainImp
//
//  Created by 이지희 on 8/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol UpdateBoostCountUseCase {
  func execute(recordId: Int, count: Int) -> Single<Void>
}
