//
//  CameraShootDuringTheMissionReactorImp.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import MissionUploadDomain
import MissionUploadPresenter
import MissionUploadCoordinator

import RecordsDomain
import ImageDomain

import DesignSystem

import ReactorKit
import RxSwift

public final class CameraShootDuringTheMissionReactorImp: CameraShootDuringTheMissionReactor {
  
  public typealias Action = CameraShootDuringTheMissionReactorAction
  public typealias Mutation = CameraShootDuringTheMissionReactorMutation
  public typealias State = CameraShootDuringTheMissionReactorState
  
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
    switch action {
    case .backButtonTapped:
      return Observable.just(Mutation.moveToMain)
    case .photoCaptured(let image):
      return Observable.just(Mutation.moveToContent(image)) /// 촬영된 이미지를 상태에 반영
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .moveToContent(let image):
      coordinator.destination.accept(.showWriteContent(image))
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    case .moveToMain:
      coordinator.requirefinish() /// Camera리엑터를 끝내고, Mission으로 복귀
      guard let tabBarViewController = coordinator.navigationController.tabBarController as? WalWalTabBarViewController else {
        return state
      }
      tabBarViewController.showCustomTabBar()
    }
    return newState
  }
}

// MARK: - Private Method
extension CameraShootDuringTheMissionReactorImp {
  
}
