//
//  FeedReactorImp.swift
//
//  Feed
//
//  Created by 이지희
//

import UIKit
import DesignSystem
import GlobalState
import ResourceKit
import Utility

import FeedDomain
import FeedPresenter
import FeedCoordinator

import ReactorKit
import RxSwift

public final class FeedReactorImp: FeedReactor {
  
  public typealias Action = FeedReactorAction
  public typealias Mutation = FeedReactorMutation
  public typealias State = FeedReactorState
  
  public let initialState: State
  public let coordinator: any FeedCoordinator
  private let fetchFeedUseCase: FetchFeedUseCase
  private let fetchNewFeedUseCase: FetchNewFeedUseCase
  
  public init(
    coordinator: any FeedCoordinator,
    fetchFeedUseCase: FetchFeedUseCase,
    fetchNewFeedUseCase: FetchNewFeedUseCase
  ) {
    self.coordinator = coordinator
    self.fetchFeedUseCase = fetchFeedUseCase
    self.fetchNewFeedUseCase = fetchNewFeedUseCase
    self.initialState = State()
  }
  
  
  /// `transform` 메서드를 사용하여 액션 스트림을 변형합니다.
  public func transform(action: Observable<Action>) -> Observable<Action> {
    /// 초기 액션으로 `initialLoadAction`를 추가
    let initialLoadAction = Observable.just(
      Action.loadFeedData(cursor: nil)
    )
    /// 기존 액션 스트림과 초기 액션 스트림을 병합
    return Observable.merge(action, initialLoadAction)
  }

  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadFeedData(let cursor):
      return fetchFeedData(cursor: cursor, limit: 10)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .feedLoadEnded(let nextCursor):
      let globalFeedModel = GlobalState.shared.feedList.value
      newState.nextCursor = nextCursor
      newState.feedData = convertFeedModel(feedList: globalFeedModel)
    case .feedFetchFailed(let errorMessage):
      newState.feedErrorMessage = errorMessage
    case .feedReachEnd:
      newState.feedFetchEnded = true
    }
    
    return newState
  }
  
  private func fetchFeedData(cursor: String?, limit: Int) -> Observable<Mutation> {
    return fetchFeedUseCase.execute(cursor: cursor, limit: limit)
      .asObservable()
      .flatMap { feedModel -> Observable<Mutation> in
        if let nextCursor = feedModel.nextCursor {
          return .just(Mutation.feedLoadEnded(nextCursor: nextCursor))
        } else {
          return .just(Mutation.feedReachEnd)
        }
      }
      .catch { error in
        return .just(
          Mutation.feedFetchFailed(
            error: error.localizedDescription
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
      let profileImage = convertImage(imageURL: feed.profileImage) ?? ResourceKitAsset.Assets.yellowDog.image
      let missionImage = convertImage(imageURL: feed.missionImage)
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
