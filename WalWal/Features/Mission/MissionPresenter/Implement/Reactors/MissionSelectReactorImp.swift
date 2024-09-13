//
//  MissionRecordSelectReactorImp.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 9/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MissionCoordinator
import MissionDomain
import MissionPresenter
import Utility

import ReactorKit

public final class MissionSelectReactorImp: MissionSelectReactor {
  public typealias Action = MissionSelectReactorAction
  public typealias Mutation = MissionSelectReactorMutation
  public typealias State = MissionSelectReactorState
  
  public let initialState: State
  public let coordinator: any MissionCoordinator
  
  public let recordId: Int
  public let missionId: Int
  public let missionTitle: String
  
  public init(
    coordinator: any MissionCoordinator,
    missionId: Int,
    recordId: Int,
    missionTitle: String
  ) {
    self.coordinator = coordinator
    self.recordId = recordId
    self.missionId = missionId
    self.missionTitle = missionTitle
    initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .didPan(translation, _):
      return Observable.just(.setSheetPosition(translation.y))
    case let .didEndPan(velocity):
      if velocity.y > 1000 {
        return Observable.just(.dismissSheet)
      } else {
        return Observable.just(.setSheetPosition(0))
      }
    case .tapDimView:
      return Observable.just(.dismissSheet)
    case .checkPhotoPermission:
      return checkPhotoPermission()
        .map{ Mutation.setPhotoPermission($0) }
    case .checkCameraPermission:
      return checkCameraPermission()
        .map{ Mutation.setCameraPermission($0) }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setSheetPosition(position):
      newState.sheetPosition = position
    case .dismissSheet:
      coordinator.dismissViewController(animated: false) { }
    case .setPhotoPermission(let isAllow):
      newState.isGrantedPhoto = isAllow
      if isAllow {
        coordinator.dismissViewController(animated: false) {
          PHPickerManager.shared.presentPicker(vc: self.coordinator.baseViewController, pickerType: .mission)
        }
      }
    case .setCameraPermission(let isAllow):
      newState.isGrantedCamera = isAllow
      if isAllow {
        coordinator.dismissViewController(animated: false) {
          self.coordinator.destination.accept(
            .startMissionUpload(
              recordId: self.recordId,
              missionId: self.missionId,
              isCamera: true,
              image: nil,
              missionTitle: self.missionTitle
            )
          )
        }
      }
    }
    return newState
  }
  
  private func checkPhotoPermission() -> Observable<Bool> {
    return PermissionManager.shared.checkPermission(for: .photo)
      .flatMap { isGranted in
        if !isGranted {
          return PermissionManager.shared.requestPhotoPermission()
        }
        return Observable.just(isGranted)
      }
  }
  
  /// 미션 시작 전 카메라 권한 확인
  private func checkCameraPermission() -> Observable<Bool> {
    PermissionManager.shared.checkPermission(for: .camera)
      .flatMap { isGranted in
        if !isGranted {
          return PermissionManager.shared.requestCameraPermission()
        }
        return Observable.just(isGranted)
      }
  }
}
