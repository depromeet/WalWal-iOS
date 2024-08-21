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
  
}

public enum MissionCoordinatorFlow: CoordinatorFlow {
  case startMissionUpload(recordId: Int, missionId: Int)
}

public protocol MissionCoordinator: BaseCoordinator where Flow == MissionCoordinatorFlow{ }
