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
  case editProfile(nickname: String, profileURL: String)
  case checkCondition(nickname: String)
}

public enum ProfileEditReactorMutation {
  case invaildNickname(message: String)
  case buttonEnable(isEnable: Bool)
  case showIndicator(show: Bool)
}

public struct ProfileEditReactorState {
  public init() { }
  public var buttonEnable: Bool = false
  public var showIndicator: Bool = false
  @Pulse public var invaildMessage: String = ""
}


public protocol ProfileEditReactor: Reactor where Action == ProfileEditReactorAction,
                                                   Mutation == ProfileEditReactorMutation,
                                                   State == ProfileEditReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator
  )
}