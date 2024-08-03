//
//  ProfileSettingReactor.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/3/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageDomain
import MyPageCoordinator

import ReactorKit
import RxSwift

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
