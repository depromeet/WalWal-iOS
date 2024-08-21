//
//  WriteContentDuringTheMissionReactor.swift
//  MissionUploadPresenter
//
//  Created by 조용인 on 8/21/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import MissionUploadDomain
import MissionUploadCoordinator

import RecordsDomain
import ImageDomain

import ReactorKit
import RxSwift

public enum WriteContentDuringTheMissionReactorAction {
  
}

public enum WriteContentDuringTheMissionReactorMutation {
  
}

public struct WriteContentDuringTheMissionReactorState {
  
  public init() {
    
  }
}

public protocol WriteContentDuringTheMissionReactor:
  Reactor where Action == WriteContentDuringTheMissionReactorAction,
                Mutation == WriteContentDuringTheMissionReactorMutation,
                State == WriteContentDuringTheMissionReactorState {
  
  var coordinator: any MissionUploadCoordinator { get }
  
  init(
    coordinator: any MissionUploadCoordinator,
    saveRecordUseCase: SaveRecordUseCase,
    uploadRecordUseCase: UploadRecordUseCase
  )
}
