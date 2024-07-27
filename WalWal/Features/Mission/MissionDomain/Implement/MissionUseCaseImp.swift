//
//  MissionUseCaseImp.swift
//  MissionDomain
//
//  Created by 이지희 on 7/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MissionData

import RxSwift

public final class MissionUseCaseImp: MissionUseCase {
  
  private let missionDataRepository: MissionRepository
  
  public init(missionDataRepository: MissionRepository) {
    self.missionDataRepository = missionDataRepository
  }
  
  public func excute() -> RxSwift.Single<MissionModel> {
    return missionDataRepository.getMissionInfo()
      .map {
        MissionModel(title: $0.title,
                     isStartMission: $0.isStartMission,
                     imageURL: $0.missionImageURL,
                     date: $0.date,
                     backgroundColorCode: $0.backgroundColorCode)
      }
      .asObservable()
      .asSingle()
  }
}
