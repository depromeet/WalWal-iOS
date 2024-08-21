//
//  ProfileEditReactorImp.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/14/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageDomain
import MyPagePresenter
import MyPageCoordinator
import Utility
import DesignSystem
import ResourceKit

import MembersDomain

import ReactorKit
import RxSwift

public final class ProfileEditReactorImp: ProfileEditReactor {
  
  public typealias Action = ProfileEditReactorAction
  public typealias Mutation = ProfileEditReactorMutation
  public typealias State = ProfileEditReactorState
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  private let editProfileUseCase: EditProfileUseCase
  private let checkNicknameUseCase: CheckNicknameUseCase
  private let fetchMemberInfoUseCase: FetchMemberInfoUseCase
  private var initProfileData: WalWalProfileModel?
  private var initNickname: String = ""
  
  public init(
    coordinator: any MyPageCoordinator,
    editProfileUseCase: EditProfileUseCase,
    checkNicknameUseCase: CheckNicknameUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase
  ) {
    self.editProfileUseCase = editProfileUseCase
    self.checkNicknameUseCase = checkNicknameUseCase
    self.fetchMemberInfoUseCase = fetchMemberInfoUseCase
    self.initialState = State()
    self.coordinator = coordinator
  }
  
  public func transform(action: Observable<ProfileEditReactorAction>) -> Observable<ProfileEditReactorAction> {
    let loadProfileInfo = Observable.just(Action.loadProfile)
    return .merge(action, loadProfileInfo)
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .checkCondition(nickname, profile):
      return checkValidForm(nickname: nickname, profile: profile)
    case .editProfile:
      return .concat([
        .just(.showIndicator(show: true)),
      ])
    case .checkPhotoPermission:
      return checkPhotoPermission()
        .map{ Mutation.setPhotoPermission($0) }
    case .tapCancelButton:
      return .just(.moveToBack)
    case .loadProfile:
      return fetchProfile()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .buttonEnable(isEnable):
      newState.buttonEnable = isEnable
    case let .invalidNickname(message):
      newState.invalidMessage = message
    case let .showIndicator(show):
      newState.showIndicator = show
    case let .setPhotoPermission(isAllow):
      newState.isGrantedPhoto = isAllow
    case .moveToBack:
      coordinator.popViewController(animated: true)
    case let .profileInfo(info):
      newState.profileInfo = info
    }
    return newState
  }
  
}

extension ProfileEditReactorImp {
  private func fetchProfile() -> Observable<Mutation> {
    return fetchMemberInfoUseCase.execute()
      .map { MemberModel(global: $0) }
      .asObservable()
      .flatMap { info -> Observable<Mutation> in
        let profileType: ProfileType = info.profileImage == nil ? .defaultImage : .selectImage
        var defaultName: DefaultProfile?
        if let defaultImageName = info.defaultImageName {
          defaultName = DefaultProfile(rawValue: defaultImageName)
        }
        let profileModelType = WalWalProfileModel(
          profileType: profileType,
          selectImage: info.profileImage,
          defaultImage: defaultName
        )
        self.initProfileData = profileModelType
        self.initNickname = info.nickname
        return .just(.profileInfo(info: info))
      }
  }
  
  private func checkPhotoPermission() -> Observable<Bool> {
    return PermissionManager.shared.checkPermission(for: .photo)
      .flatMap { isGranted in
        if !isGranted {
          return PermissionManager.shared.requestPhotoPermission()
        }
        return Observable.just(isGranted)
      }
  }
  
  private func checkValidForm(nickname: String, profile: WalWalProfileModel) -> Observable<Mutation> {
    
    if let initProfileData = initProfileData,
        initProfileData == profile,
        nickname == initNickname {
      
      return .just(.buttonEnable(isEnable: false))
    }
    
    else if nickname.count < 2 {
      return .just(.buttonEnable(isEnable: false))
    }
    else if nickname.count > 14 {
      return .concat([
        .just(.buttonEnable(isEnable: false)),
        .just(.invalidNickname(message: "14글자 이내로 입력해주세요"))
      ])
    } else if !nickname.isValidNickName() {
      return .concat([
        .just(.buttonEnable(isEnable: false)),
        .just(.invalidNickname(message: "영문, 한글만 입력할 수 있어요"))
      ])
    } else {
      return .just(.buttonEnable(isEnable: true))
    }
  }
}
