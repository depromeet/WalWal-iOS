//
//  MyPageCoordinatorInterface.swift
//
//  MyPage
//
//  Created by 조용인
//

import UIKit
import BaseCoordinator

public enum MyPageCoordinatorAction: ParentAction {
  case startAuth
}

public enum MyPageCoordinatorFlow: CoordinatorFlow {
  case showRecordDetail(
    nickname: String,
    memberId: Int,
    recordId: Int
  )
  case showProfileEdit(
    nickname: String,
    defaultProfile: String?,
    selectImage: UIImage?,
    raisePet: String
  )
  case showProfileSetting
  case showPrivacyInfoPage
  case showServiceInfoPage
}

public protocol MyPageCoordinator: BaseCoordinator
where Flow == MyPageCoordinatorFlow,
      Action == MyPageCoordinatorAction{
  func startAuth()
}
