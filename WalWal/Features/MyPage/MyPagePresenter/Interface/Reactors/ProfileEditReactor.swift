//
//  ProfileEditReactor.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageDomain
import MyPageCoordinator
import DesignSystem

import MembersDomain
import ImageDomain

import ReactorKit
import RxSwift

public enum ProfileEditReactorAction {
  case editProfile(nickname: String, profile: WalWalProfileModel)
  case checkCondition(nickname: String, profile: WalWalProfileModel)
  case checkPhotoPermission
  case tapCancelButton
  case loadProfile
}

public enum ProfileEditReactorMutation {
  case invalidNickname(message: String)
  case buttonEnable(isEnable: Bool)
  case showIndicator(show: Bool)
  case setPhotoPermission(Bool)
  case moveToBack
  case profileInfo(info: MemberModel)
  
}

public struct ProfileEditReactorState {
  public init() { }
  public var buttonEnable: Bool = false
  public var showIndicator: Bool = false
  @Pulse public var isGrantedPhoto: Bool = false
  @Pulse public var invalidMessage: String = ""
  public var profileInfo: MemberModel?
}


public protocol ProfileEditReactor: Reactor where Action == ProfileEditReactorAction,
                                                   Mutation == ProfileEditReactorMutation,
                                                   State == ProfileEditReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator,
    editProfileUseCase: EditProfileUseCase,
    checkNicknameUseCase: CheckNicknameUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase,
    uploadMemberUseCase: UploadMemberUseCase,
    memberInfoUseCase: MemberInfoUseCase
  )
}
