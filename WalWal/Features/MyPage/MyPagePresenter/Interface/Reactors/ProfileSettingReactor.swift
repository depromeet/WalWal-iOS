//
//  ProfileSettingReactor.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/3/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import MyPageDomain
import MyPageCoordinator

import ReactorKit
import RxSwift

// Cell 구성 모델
public struct Setting {
  let title: String
  let iconImage: UIImage
  let subTitle: String
  let rightText: String
}

public enum ProfileSettingReactorAction {
  
}

public enum ProfileSettingReactorMutation {
  
}

public struct ProfileSettingReactorState {
  public init() {
  
  }
}

public protocol ProfileSettingReactor: Reactor where Action == ProfileSettingReactorAction, Mutation == ProfileSettingReactorMutation, State == ProfileSettingReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator
  )
}
