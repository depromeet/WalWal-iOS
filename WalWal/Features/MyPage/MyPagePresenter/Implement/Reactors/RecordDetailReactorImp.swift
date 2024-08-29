//
//  RecordDetailReactorImp.swift
//  MyPagePresenter
//
//  Created by 이지희 on 8/4/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import MyPageDomain
import MyPagePresenter
import MyPageCoordinator

import FeedDomain
import GlobalState
import DesignSystem
import ResourceKit

import ReactorKit
import RxSwift

public final class RecordDetailReactorImp: RecordDetailReactor {
  
  public typealias Action = RecordDetailReactorAction
  public typealias Mutation = RecordDetailReactorMutation
  public typealias State = RecordDetailReactorState
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  
  private let fetchUserFeedUseCase: FetchUserFeedUseCase
  
  public init(
    coordinator: any MyPageCoordinator,
    fetchUserFeedUseCase: FetchUserFeedUseCase,
    memberId: Int
  ) {
    self.fetchUserFeedUseCase = fetchUserFeedUseCase
    self.initialState = State(memberId: memberId)
    self.coordinator = coordinator
  }
  
  public func transform(action: Observable<Action>) -> Observable<Action> {
    let initialLoadAction = Observable.just(
      Action.loadFeed(memberId: initialState.memberId, cursorDate: nil)
    )
    
    return Observable.merge(initialLoadAction, action)
  }
  
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadFeed(let memberId, let cursorDate):
      if currentState.feedFetchEnded {
        return .empty()
      }
      return fetchFeedData(memberId: memberId, cursor: cursorDate, limit: 30)
    case .tapBackButton:
      return .just(Mutation.moveToBack)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .fetchUseFeed(memberId: _, nextCursor: let nextCursor, let record):
      newState.nextCursor = nextCursor
      newState.feedData = record
    case .userFeedReachEnd(let record):
      newState.feedData = record
      newState.feedFetchEnded = true
    case .userFeedFetchFailed(let error):
      newState.feedErrorMessage = error
    case .moveToBack:
      if let tabBarViewController = coordinator.navigationController.tabBarController
          as? WalWalTabBarViewController {
        tabBarViewController.showCustomTabBar()
      }
      coordinator.popViewController(animated: true)
    }
    
    return newState
  }
  
  private func fetchFeedData(memberId: Int, cursor: String?, limit: Int) -> Observable<Mutation> {
    return fetchUserFeedUseCase.execute(memberId: memberId, cursor: cursor, limit: limit)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, feedModel -> Observable<Mutation> in
        let cursor = feedModel.nextCursor
        return owner.convertFeedModel(feedList: GlobalState.shared.recordList.value)
          .map { feedData in
            if let cursor {
              return Mutation.fetchUseFeed(memberId: memberId, nextCursor: cursor, newRecord: feedData)
            } else {
              return Mutation.userFeedReachEnd(newRecord: feedData)
            }
          }
      }
      .catch { error in
        return .just(
          Mutation.userFeedFetchFailed(
            errorMessage: error.localizedDescription
          )
        )
      }
  }
  
  private func convertFeedModel(feedList: [GlobalFeedListModel]) -> Observable<[WalWalFeedModel]> {
    let feedObservables = feedList.map { feed -> Observable<WalWalFeedModel?> in
      return Observable.zip(
        convertImage(imageURL: feed.missionImage),
        convertImage(imageURL: feed.profileImage)
      )
      .map { missionImage, profileImage in
        let profileImageOrDefault = profileImage ?? ResourceKitAsset.Assets.yellowDog.image
        return WalWalFeedModel(
          recordId: feed.recordID,
          authorId: feed.authorID,
          date: feed.createdDate,
          nickname: feed.authorNickname,
          missionTitle: feed.missionTitle,
          profileImage: profileImageOrDefault,
          missionImage: missionImage,
          boostCount: feed.boostCount,
          contents: feed.contents ?? ""
        )
      }
    }
    
    return Observable.zip(feedObservables)
      .map { $0.compactMap { $0 } }
  }
  
  private func convertImage(imageURL: String?) -> Observable<UIImage?> {
    guard let imageURL = imageURL else {
      return .just(nil)
    }
    
    if let defaultImage = DefaultProfile(rawValue: imageURL) {
      return .just(defaultImage.image) // 기본 이미지 반환
    } else if let cachedImage = GlobalState.shared.imageStore[imageURL] {
      return .just(cachedImage)
    } else {
      return GlobalState.shared.downloadAndCacheImage(for: imageURL)
        .map { _ in
          GlobalState.shared.imageStore[imageURL]
        }
    }
  }
}
