//
//  WriteContentDuringTheMissionReactorImp.swift
//  MissionUploadPresenter
//
//  Created by 조용인 on 8/21/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MissionUploadDomain
import MissionUploadPresenter
import MissionUploadCoordinator

import RecordsDomain
import ImageDomain

import ReactorKit
import RxSwift

public final class WriteContentDuringTheMissionReactorImp: WriteContentDuringTheMissionReactor {
  
  public typealias Action = WriteContentDuringTheMissionReactorAction
  public typealias Mutation = WriteContentDuringTheMissionReactorMutation
  public typealias State = WriteContentDuringTheMissionReactorState
  
  public let initialState: State
  public let coordinator: any MissionUploadCoordinator
  public let saveRecordUseCase: SaveRecordUseCase
  public let uploadRecordUseCase: UploadRecordUseCase
  
  private let disposeBag = DisposeBag()
  
  public init(
    coordinator: any MissionUploadCoordinator,
    saveRecordUseCase: SaveRecordUseCase,
    uploadRecordUseCase: UploadRecordUseCase
  ) {
    self.coordinator = coordinator
    self.saveRecordUseCase = saveRecordUseCase
    self.uploadRecordUseCase = uploadRecordUseCase
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
   
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    return newState
  }
}

// MARK: - Private Method
extension WriteContentDuringTheMissionReactorImp {
  
}
