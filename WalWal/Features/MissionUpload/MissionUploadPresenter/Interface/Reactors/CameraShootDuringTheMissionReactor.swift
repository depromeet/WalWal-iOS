//
//  MissionUploadReactor.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import UIKit
import MissionUploadDomain
import MissionUploadCoordinator

import RecordsDomain
import ImageDomain

import ReactorKit
import RxSwift

public enum CameraShootDuringTheMissionReactorAction {
  case photoCaptured(UIImage) /// 카메라에서 촬영된 이미지 액션
  case backButtonTapped
}

public enum CameraShootDuringTheMissionReactorMutation {
  case moveToContent(UIImage)
  case setLoading(Bool)
  case moveToMain
}

public struct CameraShootDuringTheMissionReactorState {
  public var isLoading: Bool = false
  
  public init() {
    
  }
}

public protocol CameraShootDuringTheMissionReactor:
  Reactor where Action == CameraShootDuringTheMissionReactorAction,
                Mutation == CameraShootDuringTheMissionReactorMutation,
                State == CameraShootDuringTheMissionReactorState {
  
  var coordinator: any MissionUploadCoordinator { get }
  
  init(
    coordinator: any MissionUploadCoordinator
  )
}
