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
  private let uploadMemberUseCase: UploadMemberUseCase
  private let memberInfoUseCase: MemberInfoUseCase
  
  private var originWalWalProfileModel: WalWalProfileModel?
  private var profileModel: MemberModel?
  
  public init(
    coordinator: any MyPageCoordinator,
    editProfileUseCase: EditProfileUseCase,
    checkNicknameUseCase: CheckNicknameUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase,
    uploadMemberUseCase: UploadMemberUseCase,
    memberInfoUseCase: MemberInfoUseCase
  ) {
    self.editProfileUseCase = editProfileUseCase
    self.checkNicknameUseCase = checkNicknameUseCase
    self.fetchMemberInfoUseCase = fetchMemberInfoUseCase
    self.uploadMemberUseCase = uploadMemberUseCase
    self.memberInfoUseCase = memberInfoUseCase
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
      return editProfileFlow(nickname: nickname, profile: profile)
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
      guard let tabBarViewController = coordinator.navigationController.tabBarController 
              as? WalWalTabBarViewController else {
        return state
      }
      tabBarViewController.showCustomTabBar()
      coordinator.dismissViewController(completion: nil)
    case let .profileInfo(info):
      newState.profileInfo = info
    case let .errorMessage(message):
      newState.errorToastMessage = message
    }
    return newState
  }
  
}

extension ProfileEditReactorImp {
  
  private func refreshMemberInfo() -> Observable<Void> {
    return memberInfoUseCase.execute(memberId: nil)
      .asObservable()
      .map { _ in Void() }
  }
  
  private func editProfileFlow(nickname: String, profile: WalWalProfileModel) -> Observable<Mutation> {
    return checkProfileImage(profile: profile)
      .withUnretained(self)
      .flatMap { owner, isValid -> Observable<Mutation> in
        if isValid {
          if owner.currentState.buttonEnable {
            return .concat([
              .just(.showIndicator(show: true)),
              owner.editProfile(nickname: nickname, profile: profile)
            ])
          } else {
            return .never()
          }
        } else {
          let errorMessage = "프로필 이미지를 등록해주세요!"
          return .just(.errorMessage(message: errorMessage))
        }
      }
  }
  
  /// 이미지 여부 체크
  private func checkProfileImage(profile: WalWalProfileModel) -> Observable<Bool> {
    if profile.profileType == .selectImage && profile.selectImage == nil {
      return .just(false)
    } else {
      return .just(true)
    }
  }
  
  /// 프로필 수정 요청
  private func editProfile(nickname: String, profile: WalWalProfileModel) -> Observable<Mutation> {
    if let profileModel = profileModel,
       nickname != profileModel.nickname { // 닉네임 수정 -> 체크 필요
      return checkNicknameUseCase.execute(nickname: nickname)
        .asObservable()
        .withUnretained(self)
        .flatMap { owner, _ -> Observable<Mutation> in
          return owner.uploadImage(nickname: nickname, profile: profile)
        }
        .catch { error  -> Observable<Mutation> in
          return .concat([
            .just(.showIndicator(show: false)),
            .just(.invalidNickname(message: error.localizedDescription))
          ])
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
    if profile.selectImage == profileModel.profileImage {
      return editRequest(nickname: nickname, profileImage: profileModel.profileURL)
    }
    guard let imagedata = profile.selectImage?.jpegData(compressionQuality: 0.8) else {
      return .just(.showIndicator(show: false))
    }
    return uploadMemberUseCase.execute(nickname: nickname, type: "JPEG", image: imagedata)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, result -> Observable<Mutation> in
        return owner.editRequest(nickname: nickname, profileImage: result.imageURL)
      }
      .catch { _ -> Observable<Mutation> in
        let errorMessage = ProfileEditError.imageUploadError.message
        return .concat([
          .just(.showIndicator(show: false)),
          .just(.errorMessage(message: errorMessage))
        ])
      }
    
  }
  
  private func editRequest(nickname: String, profileImage: String) -> Observable<Mutation> {
    return editProfileUseCase.execute(nickname: nickname, profileImage: profileImage)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.refreshMemberInfo()
      }
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<Mutation> in
        print("수정 성공")
        return owner.refreshProfile()
      }.catch { _ -> Observable<Mutation> in
        print("수정 실패")
        let errorMessage = ProfileEditError.editError.message
        return .concat([
          .just(.showIndicator(show: false)),
          .just(.errorMessage(message: errorMessage))
        ])
      }
  }
  
  private func refreshProfile() -> Observable<Mutation> {
    return memberInfoUseCase.execute(memberId: nil)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<Mutation> in
        return .concat([
          .just(.showIndicator(show: false)),
          .just(.moveToBack)
        ])
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
    } else if nickname.count < 2 {
      return .just(.buttonEnable(isEnable: false))
    } else if nickname.count > 14 {
      let errorMessage = ProfileEditError.maxLengthNickname.message
      return .concat([
        .just(.buttonEnable(isEnable: false)),
        .just(.invalidNickname(message: errorMessage))
      ])
    } else if !nickname.isValidNickName() {
      let errorMessage = ProfileEditError.nicknameInvalid.message
      return .concat([
        .just(.buttonEnable(isEnable: false)),
        .just(.invalidNickname(message: errorMessage))
      ])
    } else if profile.profileType == .selectImage && profile.selectImage == nil {
      return .just(.buttonEnable(isEnable: false))
    } else {
      return .just(.buttonEnable(isEnable: true))
    }
  }
}

fileprivate enum ProfileEditError {
  case nicknameInvalid
  case maxLengthNickname
  case editError
  case imageUploadError
  case duplicateNickname
  case needProfilePhoto
  
  var message: String {
    switch self {
    case .nicknameInvalid:
      return "영문, 한글만 입력할 수 있어요"
    case .maxLengthNickname:
      return "14글자 이내로 입력해주세요"
    case .editError:
      return "프로필 수정을 완료하지 못했어요"
    case .imageUploadError:
      return "프로필 사진을 업로드하지 못했어요"
    case .duplicateNickname:
      return "이미 누군가 사용하고 있는 닉네임이에요"
    case .needProfilePhoto:
      return "프로필 이미지를 등록해주세요!"
    }
  }
}

