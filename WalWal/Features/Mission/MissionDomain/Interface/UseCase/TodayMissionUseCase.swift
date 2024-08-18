//
//  MissionUseCase.swift
//  MissionDomain
//
//  Created by 이지희 on 7/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol TodayMissionUseCase {
  /// 미션 정보 받아오기
  func execute() -> Single<MissionModel>
}
