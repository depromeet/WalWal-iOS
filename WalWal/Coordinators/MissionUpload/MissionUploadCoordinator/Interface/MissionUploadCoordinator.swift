//
//  MissionUploadCoordinatorInterface.swift
//
//  MissionUpload
//
//  Created by 조용인
//

import UIKit
import BaseCoordinator

public enum MissionUploadCoordinatorAction: ParentAction {
  /// 미션으로 복귀하면서, fetchData한번 더 하시오
  case willFetchMissionData
}

public enum MissionUploadCoordinatorFlow: CoordinatorFlow {
  case showWriteContent(_ capturedImage: UIImage)
}

public protocol MissionUploadCoordinator: BaseCoordinator 
where Flow == MissionUploadCoordinatorFlow,
      Action == MissionUploadCoordinatorAction
{
 func fetchMissionData()
}
