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
  case showRecordDetail
  case showProfileEdit
  case showProfileSetting
}

public protocol MyPageCoordinator: BaseCoordinator
where Flow == MyPageCoordinatorFlow,
      Action == MyPageCoordinatorAction{
  func startAuth()
}
