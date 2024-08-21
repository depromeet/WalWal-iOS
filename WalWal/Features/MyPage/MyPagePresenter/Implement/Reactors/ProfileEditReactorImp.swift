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
import ImageDomain

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
  private let uploadMemberUseCase: any UploadMemberUseCase
  
  private var originWalWalProfileModel: WalWalProfileModel?
  private var profileModel: MemberModel?
  
  public init(
    coordinator: any MyPageCoordinator,
    editProfileUseCase: EditProfileUseCase,
    checkNicknameUseCase: CheckNicknameUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase,
    uploadMemberUseCase: UploadMemberUseCase
  ) {
    self.editProfileUseCase = editProfileUseCase
    self.checkNicknameUseCase = checkNicknameUseCase
    self.fetchMemberInfoUseCase = fetchMemberInfoUseCase
    self.uploadMemberUseCase = uploadMemberUseCase
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
    case let .editProfile(nickname, profile):
      
      return .concat([
        .just(.showIndicator(show: true)),
        editProfile(nickname: nickname, profile: profile)
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
  
  private func editProfile(nickname: String, profile: WalWalProfileModel) -> Observable<Mutation> {
    if let profileModel = profileModel, 
        nickname != profileModel.nickname { // 닉네임 수정 -> 체크 필요
      return checkNicknameUseCase.execute(nickname: nickname)
        .asObservable()
        .withUnretained(self)
        .flatMap { owner, _ -> Observable<Mutation> in
          return owner.uploadImage(nickname: nickname, profile: profile)
        } .catch { error  -> Observable<Mutation> in
          return .just(.invalidNickname(message: error.localizedDescription))
        }
    } else { // 닉네임 수정하지 않았음
      return uploadImage(nickname: nickname, profile: profile)
    }
  }
  
  private func uploadImage(nickname: String, profile: WalWalProfileModel) -> Observable<Mutation> {
    guard let profileModel = profileModel else { return .never() }
    
    // 기본 이미지로 변경
    if profile.profileType == .defaultImage,
        let defaultImage = profile.defaultImage {
      return editRequest(nickname: nickname, profileImage: defaultImage.rawValue)
    }
    
    // 이미지가 변경되지 않음
    guard let image = profile.selectImage else {
      return editRequest(nickname: nickname, profileImage: profileModel.profileURL)
    }
    guard let imagedata = image.jpegData(compressionQuality: 0.8) else {
      return .never()
    }
    return uploadMemberUseCase.execute(nickname: nickname, type: "JPEG", image: imagedata)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, result -> Observable<Mutation> in
        return owner.editRequest(nickname: nickname, profileImage: result.imageURL)
      }
      .catch { _ -> Observable<Mutation> in
        return .just(.showIndicator(show: false)) // TODO: - toast로 에러 메세지?
      }
    
  }
  
  private func editRequest(nickname: String, profileImage: String) -> Observable<Mutation> {
    return editProfileUseCase.execute(nickname: nickname, profileImage: profileImage)
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in
        print("수정 성공") // TODO: - pop, mypage에 반영
        return .just(.showIndicator(show: false))
      }.catch { _ -> Observable<Mutation> in
        print("수정 실패")
        return .just(.showIndicator(show: false))
      }
  }
  
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
        self.originWalWalProfileModel = profileModelType
        self.profileModel = info
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
    
    if let initProfileData = originWalWalProfileModel,
       let profileModel = profileModel,
        initProfileData == profile,
       nickname == profileModel.nickname {
      
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
