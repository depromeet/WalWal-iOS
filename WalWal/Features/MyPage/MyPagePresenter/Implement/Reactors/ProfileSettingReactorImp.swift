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
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewDidLoad:
      return Observable.concat([
        Observable.just(.setLoading(true)),
        fetchAppVersion().map { Mutation.setAppVersion($0) },
        Observable.just(.setLoading(false))
      ])
    case .tapLogoutButton:
      // Handle logout logic here
      return Observable.just(.setLogout(true))
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading
    case let .setAppVersion(fetchedVersion):
      let currentVersion = getCurrentAppVersion()
      newState.appVersionString = currentVersion
      let isRecent = fetchedVersion <= currentVersion
      newState.settings = [
        .init(title: "로그아웃",
              iconImage: AssetImage._16x16NextButton.image,
              subTitle: "",
              rightText: ""),
        .init(title: "버전 정보",
              iconImage: AssetImage._16x16NextButton.image,
              subTitle: currentVersion,
              rightText: isRecent ? "최신 버전입니다." : "업데이트 필요"),
        .init(title: "회원 탈퇴",
              iconImage: AssetImage._16x16NextButton.image,
              subTitle: "",
              rightText: "")
      ]
    case let .setSettingItemModel(settings):
      newState.settings = settings
    case let .setLogout(success):
      newState.isSuccess = success
    }
    return newState
  }
  
  
  private func fetchAppVersion() -> Observable<String> {
      return Observable<String>.create { observer in
        // 실제 마켓 버전 받아오는 로직 필요
          let fetchedVersion = "1.0"
          observer.onNext(fetchedVersion)
          observer.onCompleted()
          return Disposables.create()
      }
  }

  private func getCurrentAppVersion() -> String {
      guard let dictionary = Bundle.main.infoDictionary,
            let version = dictionary["CFBundleShortVersionString"] as? String else {
          return ""
      }
      return version
  }
}

