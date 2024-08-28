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
  case backButtonTapped
  case uploadButtonTapped(capturedImage: UIImage, content: String)
  case deleteThisContent
  case keepThisContent
}

public enum WriteContentDuringTheMissionReactorMutation {
  case showMeTheAlert(show: Bool) /// 뒤로가기 버튼을 누르고, 얼럿을 띄우고 지우기 (isAlertWillPresent)
  case uploadProcessEnded /// 업로드 프로세스가 끝났어요~
  case uploadFailed(message: String)
  case moveToMain /// 미션으로 돌아가자~
  case showLottie(show: Bool)
}

public struct WriteContentDuringTheMissionReactorState {
  public var isAlertWillPresent: Bool = false
  @Pulse public var uploadErrorMessage: String = ""
  public var showLottie: Bool = false
  
  public init() {}
}

public protocol WriteContentDuringTheMissionReactor:
  Reactor where Action == WriteContentDuringTheMissionReactorAction,
                Mutation == WriteContentDuringTheMissionReactorMutation,
                State == WriteContentDuringTheMissionReactorState {
  
  var coordinator: any MissionUploadCoordinator { get }
  
  init(
    coordinator: any MissionUploadCoordinator,
    saveRecordUseCase: SaveRecordUseCase,
    uploadRecordUseCase: UploadRecordUseCase,
    recordId: Int,
    missionId: Int
  )
}
