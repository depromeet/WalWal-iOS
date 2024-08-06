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

import ReactorKit
import RxSwift

public final class ProfileSettingReactorImp: ProfileSettingReactor {
  public typealias Action = ProfileSettingReactorAction
  public typealias Mutation = ProfileSettingReactorMutation
  public typealias State = ProfileSettingReactorState
  
  private typealias AssetImage = ResourceKitAsset.Assets
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  
  public init(
    coordinator: any MyPageCoordinator
  ) {
    self.coordinator = coordinator
    self.initialState = State(
      isLoading: false,
      isLogoutSuccess: false,
      isRevokeSuccess: false,
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
      return handleSelection(at: indexPath)
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
    case let .setLogout(success):
      newState.isLogoutSuccess = success
    case let .setRevoke(success):
      newState.isRevokeSuccess = success
    case let .setIsRecentVersion(isRecent):
      newState.isRecent = isRecent
    }
    return newState
  }
  
  private func handleSelection(at indexPath: IndexPath) -> Observable<Mutation> {
    if indexPath.row == 0 {
      // 로그아웃 로직 추가
      print("로그아웃")
      return Observable.just(.setLogout(true))
    } else if indexPath.row == 2 {
      // 회원 탈퇴 로직 추가
      print("회원탈퇴")
      return Observable.just(.setRevoke(true))
    }
    return Observable.empty()
  }
  
  private func fetchAppVersion() -> Observable<Mutation> {
    let fetchedVersion = "1.0" // 실제 앱스토어 버전 받아오는 로직 필요
    let currentVersion = self.getCurrentAppVersion()
    let isRecent = currentVersion >= fetchedVersion
    
    return Observable.just([
      .setAppVersion(currentVersion),
      .setIsRecentVersion(isRecent)
    ]).flatMap { Observable.from($0) }
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
            iconImage: AssetImage._16x16NextButton.image,
            subTitle: "",
            rightText: ""),
      .init(title: "버전 정보",
            iconImage: AssetImage._16x16NextButton.image,
            subTitle: appVersion,
            rightText: isRecent ? "최신 버전입니다." : "업데이트 필요"),
      .init(title: "회원 탈퇴",
            iconImage: AssetImage._16x16NextButton.image,
            subTitle: "",
            rightText: "")
    ]
  }
}
