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
public struct ProfileSettingItemModel {
  public let title: String
  public let iconImage: UIImage
  public let subTitle: String
  public let rightText: String
  
  public init(title: String, iconImage: UIImage, subTitle: String, rightText: String) {
    self.title = title
    self.iconImage = iconImage
    self.subTitle = subTitle
    self.rightText = rightText
  }
}


public enum ProfileSettingReactorAction {
  
  case viewDidLoad
  case tapLogoutButton
}

public enum ProfileSettingReactorMutation {
  case setLoading(Bool)
  case setAppVersion(String)
  case setSettingItemModel([ProfileSettingItemModel])
  case setLogout(Bool)
}

public struct ProfileSettingReactorState {
  public var isLoading: Bool
  public var isSuccess: Bool
  public var appVersionString: String
  public var settings: [ProfileSettingItemModel]
  
  public init(
    isLoading: Bool = false,
    isSuccess: Bool = false,
    appVersionString: String = "",
    settings: [ProfileSettingItemModel] = []
  ) {
    self.isLoading = isLoading
    self.isSuccess = isSuccess
    self.appVersionString = appVersionString
    self.settings = settings
  }
}

public protocol ProfileSettingReactor: Reactor where Action == ProfileSettingReactorAction, Mutation == ProfileSettingReactorMutation, State == ProfileSettingReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator
  )
}
