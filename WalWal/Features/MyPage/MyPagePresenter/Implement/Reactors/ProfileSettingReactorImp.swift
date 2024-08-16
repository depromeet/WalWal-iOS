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
  
  private typealias Images = ResourceKitAsset.Images
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  private let tokenDeleteUseCase: TokenDeleteUseCase
  
  public init(
    coordinator: any MyPageCoordinator,
    tokenDeleteUseCase: TokenDeleteUseCase
  ) {
    self.coordinator = coordinator
    self.tokenDeleteUseCase = tokenDeleteUseCase
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
        return logout()
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
      coordinator.popViewController(animated: true)
    }
    return newState
  }
  
  private func logout() -> Observable<Mutation> {
    tokenDeleteUseCase.execute()
    coordinator.startAuth()
    return .just(.moveToAuth)
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
