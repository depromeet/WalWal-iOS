//
//  WriteContentDuringTheMissionReactorImp.swift
//  MissionUploadPresenter
//
//  Created by 조용인 on 8/21/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit

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
  public let recordId: Int
  
  private let disposeBag = DisposeBag()
  
  public init(
    coordinator: any MissionUploadCoordinator,
    saveRecordUseCase: SaveRecordUseCase,
    uploadRecordUseCase: UploadRecordUseCase,
    recordId: Int
  ) {
    self.coordinator = coordinator
    self.saveRecordUseCase = saveRecordUseCase
    self.uploadRecordUseCase = uploadRecordUseCase
    self.recordId = recordId
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .backButtonTapped:
      /// 얼럿 띄우기
      coordinator.requirefinish()
      return .empty()
    case .uploadButtonTapped(let image, let content):
      return .concat([
        .just(.showCompletedLottie(show: true)),
        uploadImage(image)
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .showCompletedLottie(let isShow):
      newState.showCompletedLottie = isShow
    }
    return newState
  }
}

// MARK: - Private Method
extension WriteContentDuringTheMissionReactorImp {
  private func uploadImage(_ image: UIImage) -> Observable<Mutation> {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else { return .never() }
    return uploadRecordUseCase.execute(recordId: recordId, type: "JPEG", image: imageData)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, result -> Observable<Mutation> in
        owner.coordinator.requirefinish()
        return .just(.showCompletedLottie(show: false))
      }
      .catch { error -> Observable<Mutation> in
        return .just(.showCompletedLottie(show: false))
      }
  }
}
