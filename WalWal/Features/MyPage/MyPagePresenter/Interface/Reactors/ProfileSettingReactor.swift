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
import FCMDomain
import AuthDomain

import ReactorKit
import RxSwift

public enum ProfileSettingReactorAction {
  
  case viewDidLoad
  case logout
  case withdraw
  case tapBackButton
}

public enum ProfileSettingReactorMutation {
  case setLoading(Bool)
  case setAppVersion(String)
  case setIsRecentVersion(Bool)
  case setSettingItemModel([ProfileSettingItemModel])
  case moveToAuth
  case moveToBack
  case errorMessage(msg: String)
}

public struct ProfileSettingReactorState {
  public var isLoading: Bool
  public var appVersionString: String
  public var isRecent: Bool
  public var settings: [ProfileSettingItemModel]
  @Pulse public var errorMessage: String?
  
  public init(
    isLoading: Bool = false,
    appVersionString: String = "",
    isRecent: Bool = false,
    settings: [ProfileSettingItemModel] = []
  ) {
    self.isLoading = isLoading
    self.appVersionString = appVersionString
    self.isRecent = isRecent
    self.settings = settings
  }
}

public protocol ProfileSettingReactor: Reactor where Action == ProfileSettingReactorAction, Mutation == ProfileSettingReactorMutation, State == ProfileSettingReactorState {
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator,
    tokenDeleteUseCase: TokenDeleteUseCase,
    fcmDeleteUseCase: FCMDeleteUseCase,
    withdrawUseCase: WithdrawUseCase,
    kakaoLogoutUseCase: KakaoLogoutUseCase,
    kakaoUnlinkUseCase: KakaoUnlinkUseCase
  )
}
