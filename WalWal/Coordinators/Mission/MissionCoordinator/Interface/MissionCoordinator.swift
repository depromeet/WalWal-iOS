//
//  MissionCoordinatorInterface.swift
//
//  Mission
//
//  Created by 이지희
//

import UIKit
import BaseCoordinator

public enum MissionCoordinatorAction: ParentAction {
  case startMyPage
}

public enum MissionCoordinatorFlow: CoordinatorFlow {
  case startMissionUpload(recordId: Int, missionId: Int, isCamera: Bool, image: UIImage?)
  case showSelectMission(recordId: Int, missionId: Int)
}

public protocol MissionCoordinator: BaseCoordinator where Flow == MissionCoordinatorFlow{ 
  func startMyPage()
}
