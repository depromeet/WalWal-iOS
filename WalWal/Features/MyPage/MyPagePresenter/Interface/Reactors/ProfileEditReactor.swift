//
//  ProfileEditReactor.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageDomain
import MyPageCoordinator

import ReactorKit
import RxSwift

public enum ProfileEditReactorAction {
}

public enum ProfileEditReactorMutation {
}

public struct ProfileEditReactorState {
  public init() {
  
  }
}


public protocol ProfileEditReactor: Reactor where Action == ProfileEditReactorAction,
                                                   Mutation == ProfileEditReactorMutation,
                                                   State == ProfileEditReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator
  )
}
