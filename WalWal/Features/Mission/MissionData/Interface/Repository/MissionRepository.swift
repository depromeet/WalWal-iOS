//
//  MissionRepository.swift
//  MissionData
//
//  Created by 이지희 on 7/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol MissionRepository {
  func loadMissionInfo() -> Single<MissionInfoDTO>
}
