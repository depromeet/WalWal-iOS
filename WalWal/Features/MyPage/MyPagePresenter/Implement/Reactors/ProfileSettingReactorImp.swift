//
//  ProfileSettingReactorImp.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/3/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MyPageDomain
import MyPagePresenter
import MyPageCoordinator
import ResourceKit
import FCMDomain
import AuthDomain
import LocalStorage
import DesignSystem

import ReactorKit
import RxSwift

public final class ProfileSettingReactorImp: ProfileSettingReactor {
  public typealias Action = ProfileSettingReactorAction
  public typealias Mutation = ProfileSettingReactorMutation
  public typealias State = ProfileSettingReactorState
  
  private typealias Images = ResourceKitAsset.Images
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  private let tokenDeleteUseCase: TokenDeleteUseCase
  private let fcmDeleteUseCase: FCMDeleteUseCase
  private let withdrawUseCase: WithdrawUseCase
  private let kakaoLogoutUseCase: KakaoLogoutUseCase
  private let kakaoUnlinkUseCase: KakaoUnlinkUseCase
  
  public init(
    coordinator: any MyPageCoordinator,
    tokenDeleteUseCase: TokenDeleteUseCase,
    fcmDeleteUseCase: FCMDeleteUseCase,
    withdrawUseCase: WithdrawUseCase,
    kakaoLogoutUseCase: KakaoLogoutUseCase,
    kakaoUnlinkUseCase: KakaoUnlinkUseCase
  ) {
    self.coordinator = coordinator
    self.tokenDeleteUseCase = tokenDeleteUseCase
    self.fcmDeleteUseCase = fcmDeleteUseCase
    self.withdrawUseCase = withdrawUseCase
    self.kakaoLogoutUseCase = kakaoLogoutUseCase
    self.kakaoUnlinkUseCase = kakaoUnlinkUseCase
    self.initialState = State(
      isLoading: false,
      appVersionString: "",
      isRecent: false,
      settings: []
    )
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return Observable.concat([
        Observable.just(.setLoading(true)),
        fetchAppVersion(),
        Observable.just(.setLoading(false))
      ])
    case let .didSelectItem(at: indexPath):
      if indexPath.row == 0 {
        return .concat([
          .just(.setLoading(true)),
          deleteFCMToken(authAction: .logout)
        ])
      } else if indexPath.row == 2 {
        return .concat([
          .just(.setLoading(true)),
          deleteFCMToken(authAction: .withdraw)
        ])
      } else {
        return .never()
      }
    case .tapBackButton:
      return Observable.just(.moveToBack)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
    case let .setAppVersion(fetchedVersion):
      newState.appVersionString = fetchedVersion
      newState.isRecent = state.appVersionString <= fetchedVersion
      if state.settings.isEmpty {
        newState.settings = createSettings(appVersion: fetchedVersion, isRecent: newState.isRecent)
      }
    case let .setSettingItemModel(setting):
      newState.settings = setting
    case .moveToAuth:
      coordinator.startAuth()
    case let .setIsRecentVersion(isRecent):
      newState.isRecent = isRecent
    case .moveToBack:
      guard let tabBarViewController = coordinator.navigationController.tabBarController as? WalWalTabBarViewController else {
        return state
      }
      tabBarViewController.showCustomTabBar()
      coordinator.popViewController(animated: true)
    }
    return newState
  }
}

extension ProfileSettingReactorImp {
  private func deleteFCMToken(authAction: AuthAction) -> Observable<Mutation> {
    return fcmDeleteUseCase.execute()
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<Mutation> in
        let provider = UserDefaults.string(forUserDefaultsKey: .socialLogin)
        if authAction == .logout {
          if provider == "kakao" {
            return owner.kakaoLogout()
          } else {
            return owner.appleLogout()
          }
        } else if authAction == .withdraw {
          if provider == "kakao" {
            return owner.kakaoUnlink()
          } else {
            return owner.withdraw()
          }
        }
        return .never()
      }
      .catch { error -> Observable<Mutation> in
        print(error.localizedDescription)
        return self.tokenDeleteUseCase.execute()
          .asObservable()
          .flatMap { _ -> Observable<Mutation> in
            return .concat([
              .just(.setLoading(false)),
              .just(.moveToAuth)
            ])
          }
      }
  }
  
  private func appleLogout() -> Observable<Mutation> {
    return tokenDeleteUseCase.execute()
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in
        return .concat([
          .just(.setLoading(false)),
          .just(.moveToAuth)
        ])
      }
  }
  
  private func kakaoLogout() -> Observable<Mutation> {
    return kakaoLogoutUseCase.execute()
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.tokenDeleteUseCase.execute()
      }
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in
        return .concat([
          .just(.setLoading(false)),
          .just(.moveToAuth)
        ])
      }
      .catch { error in
        print(error.localizedDescription)
        return .just(.setLoading(false))
      }
  }
  
  
  private func withdraw() -> Observable<Mutation> {
    return withdrawUseCase.execute()
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.tokenDeleteUseCase.execute()
      }
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in
        return .concat([
          .just(.setLoading(false)),
          .just(.moveToAuth)
        ])
      }
      .catch { error -> Observable<Mutation> in
        print("탈퇴 실패 ", error.localizedDescription)
        let _ = self.tokenDeleteUseCase.execute()
        return .concat([
          .just(.setLoading(false)),
          .just(.moveToAuth)
        ])
      }
  }
  
  private func kakaoUnlink() -> Observable<Mutation> {
    return kakaoUnlinkUseCase.execute()
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<Mutation> in
        owner.withdraw()
      }
  }
  
  
  private func fetchAppVersion() -> Observable<Mutation> {
    let fetchedVersion = "1.0" // 실제 앱스토어 버전 받아오는 로직 필요
    let currentVersion = self.getCurrentAppVersion()
    let isRecent = currentVersion >= fetchedVersion
    
    return Observable.concat([
      .just(.setAppVersion(currentVersion)),
      .just(.setIsRecentVersion(isRecent))
    ])
  }
  
  private func getCurrentAppVersion() -> String {
    guard let dictionary = Bundle.main.infoDictionary,
          let version = dictionary["CFBundleShortVersionString"] as? String else {
      return ""
    }
    return version
  }
  
  private func createSettings(appVersion: String, isRecent: Bool) -> [ProfileSettingItemModel] {
    return [
      .init(title: "로그아웃",
            iconImage: Images.logout.image,
            subTitle: "",
            rightText: ""),
      .init(title: "버전 정보",
            iconImage: Images.swap.image,
            subTitle: appVersion,
            rightText: isRecent ? "최신 버전입니다." : "업데이트 필요"),
      .init(title: "회원 탈퇴",
            iconImage: Images.xSquare.image,
            subTitle: "",
            rightText: "")
    ]
  }
}

fileprivate enum AuthAction {
  case logout, withdraw
}
