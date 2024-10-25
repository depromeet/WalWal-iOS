//
//  WriteContentDuringTheMissionReactorImp.swift
//  MissionUploadPresenter
//
//  Created by 조용인 on 8/21/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import DesignSystem

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
  public let missionId: Int
  
  private let disposeBag = DisposeBag()
  
  public init(
    coordinator: any MissionUploadCoordinator,
    saveRecordUseCase: SaveRecordUseCase,
    uploadRecordUseCase: UploadRecordUseCase,
    recordId: Int,
    missionId: Int
  ) {
    self.coordinator = coordinator
    self.saveRecordUseCase = saveRecordUseCase
    self.uploadRecordUseCase = uploadRecordUseCase
    self.recordId = recordId
    self.missionId = missionId
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .deleteThisContent:
      return .just(Mutation.moveToMain)
    case .uploadButtonTapped(let image, let content): /// 피드 공유하기 버튼 눌렀어
      return .concat([
        .just(Mutation.showLottie(show: true)),
        uploadProcess(content, image)
      ])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .showLottie(show):
      newState.showLottie = show
    case .uploadFailed(message: let message):
      newState.uploadErrorMessage = message
      newState.showLottie = false
    case .uploadProcessEnded:
      passFlagAndMoveToMission()
    case .moveToMain:
      justMoveToMission()
    }
    return newState
  }
}

// MARK: - Private Method
extension WriteContentDuringTheMissionReactorImp {
  
  private func passFlagAndMoveToMission() {
    guard let tabBarViewController = coordinator.navigationController.tabBarController as? WalWalTabBarViewController else {
      return
    }
    tabBarViewController.showCustomTabBar()
    coordinator.fetchMissionData()
  }
  
  private func justMoveToMission() {
    guard let tabBarViewController = coordinator.navigationController.tabBarController as? WalWalTabBarViewController else {
      return 
    }
    tabBarViewController.showCustomTabBar()
    coordinator.requirefinish()
  }
  
  private func uploadProcess(_ content: String, _ image: UIImage) -> Observable<Mutation> {
    return saveRecordUseCase.execute(missionId: missionId, content: content)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, result -> Observable<Mutation> in
        return owner.uploadImage(image)
      }
      .catch { error -> Observable<Mutation> in
        return .concat([
          .just(.uploadFailed(message: error.localizedDescription)),
          .just(.showLottie(show: false))
        ])
      }
  }
  
  private func uploadImage(_ image: UIImage) -> Observable<Mutation> {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else { return .never() }
    return uploadRecordUseCase.execute(recordId: recordId, type: "JPEG", image: imageData)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, result -> Observable<Mutation> in
        return .concat([
          .just(.uploadProcessEnded),
          .just(.showLottie(show: false))
        ])
      }
      .catch { error -> Observable<Mutation> in
        return .concat([
          .just(.uploadFailed(message: error.localizedDescription)),
          .just(.showLottie(show: false))
        ])
      }
  }
}
