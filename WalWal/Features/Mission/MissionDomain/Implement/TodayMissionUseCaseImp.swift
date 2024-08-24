//
//  MissionUseCaseImp.swift
//  MissionDomain
//
//  Created by 이지희 on 7/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MissionData
import MissionDomain

import RxSwift

public final class TodayMissionUseCaseImp: TodayMissionUseCase {
  
  private let missionDataRepository: MissionRepository
  
  public init(missionDataRepository: MissionRepository) {
    self.missionDataRepository = missionDataRepository
  }
  
  public func execute() -> Single<MissionModel> {
    return missionDataRepository.loadMissionInfo()
      .map {
        let missionModel = MissionModel(dto: $0)
        missionModel.saveToGlobalState()
        return missionModel
      }
      .asObservable()
      .asSingle()
  }
}
