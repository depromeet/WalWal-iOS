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
      return checkNickname(nickname: nickname, profile: profile, petType: petType)
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
    }
    return newState
  }
}


extension OnboardingProfileReactorImp {
  
  /// 닉네임 중복 여부 체크 메서드
  private func checkNickname(nickname: String, profile: ProfileCellModel, petType: String) -> Observable<Mutation> {
    return nicknameValidUseCase.excute(nickname: nickname)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, result -> Observable<Mutation> in
        return owner.uploadImage(profile: profile, nickname: nickname)
      }
      .catch { error -> Observable<Mutation> in
        return .just(.invalidNickname(message: "이미 누군가 사용하고 있는 닉네임이에요"))
      }
      
  }
  
  // TODO: - 프로필 업로드 요청 메서드
  private func uploadImage(profile: ProfileCellModel, nickname: String) -> Observable<Mutation> {
    guard let imagedata = profile.curImage?.jpegData(compressionQuality: 0.8) else { return .never() }
    return uploadImageUseCase.excute(nickname: nickname, type: "JPEG", image: imagedata)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, result -> Observable<Mutation> in
        return owner.register(nickname: nickname, petType: "DOG")
      }
      .catch { error -> Observable<Mutation> in
        return .never()
      }
  }
  
  /// 최종 회원가입 요청 메서드
  private func register(nickname: String, petType: String) -> Observable<Mutation> {
    return registerUseCase.excute(nickname: nickname, pet: petType)
      .asObservable()
      .flatMap { result -> Observable<Mutation> in
        // TODO: - 미션 뷰 이동
        return .never()
      }
      .catch { error -> Observable<Mutation> in
        return .just(.registerError(message: "회원가입을 완료하지 못했어요"))
      }
  }
  
  
  private func checkValidForm(nickname: String, profile: ProfileCellModel) -> Observable<Mutation> {
    if nickname.count < 2 {
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
    } else if profile.profileType == .selectImage && profile.curImage == nil {
      return .just(.buttonEnable(isEnable: false))
    } else {
      return .just(.buttonEnable(isEnable: true))
    }
  }
  
}
