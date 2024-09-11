//
//  MissionSelectReactor.swift
//  MissionPresenterImp
//
//  Created by 이지희 on 9/7/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MissionCoordinator

import MissionDomain
import RecordsDomain

import ReactorKit
import RxSwift
import UIKit

public enum MissionSelectReactorAction {
  case didPan(translation: CGPoint, velocity: CGPoint)
  case didEndPan(velocity: CGPoint)
  case tapDimView
  
  case checkPhotoPermission
  
  case moveToMissionUploadCamera
  case moveToMissionGallery(image: UIImage)
}

public enum MissionSelectReactorMutation {
  // Sheet관련
  case setSheetPosition(CGFloat)
  case dismissSheet
  
  case setPhotoPermission(Bool)
  
  // 미션 업로드
  case startMissionUploadProcess(Bool, UIImage?)
}


public struct MissionSelectReactorState {
  public var sheetPosition: CGFloat = 0
  @Pulse public var isGrantedPhoto: Bool = false
  
  public init() { }
}

public protocol MissionSelectReactor: Reactor where Action == MissionSelectReactorAction, Mutation == MissionSelectReactorMutation, State == MissionSelectReactorState {
  
  var coordinator: any MissionCoordinator { get }
  
  init(
    coordinator: any MissionCoordinator,
    missionId: Int,
    recordId: Int,
    missionTitle: String
  )
}
