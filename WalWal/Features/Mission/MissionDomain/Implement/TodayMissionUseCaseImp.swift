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
  
  public func excute() -> Single<MissionModel> {
    return missionDataRepository.loadMissionInfo()
      .map {
        MissionModel(
          id: $0.id,
          title: $0.title,
          imageURL: $0.illustrationURL
        )
      }
      .asObservable()
      .asSingle()
  }
}
