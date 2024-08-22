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
    fetchUserFeedUseCase: FetchUserFeedUseCase
  ) {
    self.fetchUserFeedUseCase = fetchUserFeedUseCase
    self.initialState = State()
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
      return fetchFeedData(memberId: memberId, cursor: cursorDate, limit: 10)
    case .tapBackButton:
      return .just(Mutation.moveToBack)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .fetchUseFeed(memberId: _, nextCursor: let nextCursor):
      let globalRecordModel = GlobalState.shared.recordList.value
      newState.nextCursor = nextCursor
      if globalRecordModel.count < 10 {
        newState.feedFetchEnded = true
      }
      newState.feedData = convertFeedModel(feedList: globalRecordModel)
    case .userFeedReachEnd:
      newState.feedFetchEnded = true
    case .userFeedFetchFailed(let error):
      newState.feedErrorMessage = error
    case .moveToBack:
      guard let tabBarViewController = coordinator.navigationController.tabBarController
              as? WalWalTabBarViewController else {
        return state
      }
      tabBarViewController.showCustomTabBar()
      coordinator.popViewController(animated: true)
    }
    
    return newState
  }
  
  private func fetchFeedData(memberId: Int, cursor: String?, limit: Int) -> Observable<Mutation> {
    return fetchUserFeedUseCase.execute(memberId: memberId, cursor: cursor, limit: limit)
      .asObservable()
      .flatMap { feedModel -> Observable<Mutation> in
        if let nextCursor = feedModel.nextCursor {
          return .just(Mutation.fetchUseFeed(memberId: memberId, nextCursor: nextCursor))
        } else {
          if feedModel.list.count < limit {
            return .just(Mutation.fetchUseFeed(memberId: memberId, nextCursor: ""))
          }
          return .just(Mutation.userFeedReachEnd)
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
  
  
  
  private func convertImage(imageURL: String?) -> UIImage? {
    if let imageURL {
      guard let image = GlobalState.shared.imageStore[imageURL] else { return nil }
      return image
    } else {
      return nil
    }
  }
  
  private func convertFeedModel(feedList: [GlobalFeedListModel]) -> [WalWalFeedModel]{
    return feedList.compactMap { feed in
      let missionImage = convertImage(imageURL: feed.missionImage)
      
      let profileImage = convertImage(imageURL: feed.profileImage) ?? ResourceKitAsset.Assets.yellowDog.image
      return WalWalFeedModel(
        id: feed.recordID,
        date: feed.createdDate,
        nickname: feed.authorNickname,
        missionTitle: feed.missionTitle,
        profileImage: profileImage,
        missionImage: missionImage,
        boostCount: feed.boostCount
      )
    }
  }
}
