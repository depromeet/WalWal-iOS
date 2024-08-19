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
  case completedUploadMissionData /// 미션 데이터 업로드를 마치고, 다시 미션으로 복귀해야햄
}

public enum MissionUploadCoordinatorFlow: CoordinatorFlow {
  case showWriteContent(capturedImage: UIImage)
}

public protocol MissionUploadCoordinator: BaseCoordinator 
where Flow == MissionUploadCoordinatorFlow,
      Action == MissionUploadCoordinatorAction
{
 
}
