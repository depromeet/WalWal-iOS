//
//  OnboardingProfileReactor.swift
//  OnboardingPresenter
//
//  Created by Jiyeon on 7/31/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import OnboardingDomain
import OnboardingCoordinator
import OnboardingPresenter
import Utility
import DesignSystem
import LocalStorage

import ReactorKit
import RxSwift

public final class OnboardingProfileReactorImp: OnboardingProfileReactor {
  public typealias Action = OnboardingProfileReactorAction
  public typealias Mutation = OnboardingProfileReactorMutation
  public typealias State = OnboardingProfileReactorState
  
  public let initialState: State
  public let coordinator: any OnboardingCoordinator
  private let registerUseCase: any RegisterUseCase
  private let nicknameValidUseCase: any NicknameValidUseCase
  private let uploadImageUseCase: any UploadImageUseCase
  
  public init(
    coordinator: any OnboardingCoordinator,
    registerUseCase: any RegisterUseCase,
    nicknameValidUseCase: any NicknameValidUseCase,
    uploadImageUseCase: any UploadImageUseCase
  ) {
    self.coordinator = coordinator
    self.registerUseCase = registerUseCase
    self.nicknameValidUseCase = nicknameValidUseCase
    self.uploadImageUseCase = uploadImageUseCase
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .register(nickname, profile, petType):
      return .concat([
        .just(.showIndicator(show: true)),
        checkNickname(nickname: nickname, profile: profile, petType: petType)
      ])
    case let .checkCondition(nickname, profile):
      return checkValidForm(nickname: nickname, profile: profile)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .buttonEnable(isEnable):
      newState.buttonEnable = isEnable
    case let .invalidNickname(message):
      newState.invalidMessage = message
    case let .registerError(message):
      newState.errorMessage = message
    case let .showIndicator(show):
      newState.showIndicator = show
    }
    return newState
  }
}


extension OnboardingProfileReactorImp {
  
  /// 닉네임 중복 여부 체크 메서드
  private func checkNickname(nickname: String, profile: WalWalProfileModel, petType: String) -> Observable<Mutation> {
    return nicknameValidUseCase.excute(nickname: nickname)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, result -> Observable<Mutation> in
        
        if profile.profileType == .selectImage { // 프로필 사진 선택
          return owner.uploadImage(profile: profile, nickname: nickname, petType: petType)
        } else { // 기본사진
          return owner.register(nickname: nickname, petType: petType, defaultProfile: profile.defaultImage?.rawValue)
        }
      }
      .catch { error -> Observable<Mutation> in
        return .concat([
          .just(.showIndicator(show: false)),
          .just(.buttonEnable(isEnable: false)),
          .just(.invalidNickname(message: OnboardingError.duplicateNickname.message))
        ])
      }
      
  }
  
  /// 프로필 이미지 업로드
  private func uploadImage(profile: WalWalProfileModel, nickname: String, petType: String) -> Observable<Mutation> {
    guard let imagedata = profile.selectImage?.jpegData(compressionQuality: 0.8) else { return .never() }
    return uploadImageUseCase.excute(nickname: nickname, type: "JPEG", image: imagedata)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, result -> Observable<Mutation> in
        return owner.register(nickname: nickname, petType: petType)
      }
      .catch { error -> Observable<Mutation> in
        return .concat([
          .just(.showIndicator(show: false)),
          .just(.registerError(message: OnboardingError.imageUploadError.message))
        ])
      }
  }
  
  /// 최종 회원가입 요청 메서드
  private func register(nickname: String, petType: String, defaultProfile: String? = nil) -> Observable<Mutation> {
    return registerUseCase.excute(nickname: nickname, petType: petType, defaultProfile: defaultProfile)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, result -> Observable<Mutation> in
        UserDefaults.setValue(value: result.refreshToken, forUserDefaultKey: .refreshToken)
        let _ = KeychainWrapper.shared.setAccessToken(result.accessToken)
        owner.coordinator.startMission()
        return .just(.showIndicator(show: false))
      }
      .catch { error -> Observable<Mutation> in
        return .concat([
          .just(.showIndicator(show: false)),
          .just(.registerError(message: OnboardingError.registerError.message))
        ])
      }
  }
  
  
  private func checkValidForm(nickname: String, profile: WalWalProfileModel) -> Observable<Mutation> {
    if nickname.count < 2 {
      return .just(.buttonEnable(isEnable: false))
    }
    else if nickname.count > 14 {
      return .concat([
        .just(.buttonEnable(isEnable: false)),
        .just(.invalidNickname(message: OnboardingError.maxLengthNickname.message))
      ])
    } else if !nickname.isValidNickName() {
      return .concat([
        .just(.buttonEnable(isEnable: false)),
        .just(.invalidNickname(message: OnboardingError.nicknameInvalid.message))
      ])
    } else if profile.profileType == .selectImage && profile.selectImage == nil {
      return .just(.buttonEnable(isEnable: false))
    } else {
      return .just(.buttonEnable(isEnable: true))
    }
  }
  
}

fileprivate enum OnboardingError {
  case nicknameInvalid
  case maxLengthNickname
  case registerError
  case imageUploadError
  case duplicateNickname
  
  var message: String {
    switch self {
    case .nicknameInvalid:
      return "영문, 한글만 입력할 수 있어요"
    case .maxLengthNickname:
      return "14글자 이내로 입력해주세요"
    case .registerError:
      return "회원가입을 완료하지 못했어요"
    case .imageUploadError:
      return "프로필 사진을 업로드하지 못했어요"
    case .duplicateNickname:
      return "이미 누군가 사용하고 있는 닉네임이에요"
    }
  }
}
