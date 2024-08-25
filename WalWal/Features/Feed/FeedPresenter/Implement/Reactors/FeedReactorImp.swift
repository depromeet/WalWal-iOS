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
  
  public init(
    coordinator: any FeedCoordinator,
    fetchFeedUseCase: FetchFeedUseCase
  ) {
    self.coordinator = coordinator
    self.fetchFeedUseCase = fetchFeedUseCase
    self.initialState = State()
  }
  
  
  /// `transform` 메서드를 사용하여 액션 스트림을 변형합니다.
  public func transform(action: Observable<Action>) -> Observable<Action> {
    /// 초기 액션으로 `initialLoadAction`를 추가
    let initialLoadAction = Observable.just(
      Action.loadFeedData(cursor: nil)
    )
    /// 기존 액션 스트림과 초기 액션 스트림을 병합
    return Observable.merge(initialLoadAction, action)
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadFeedData(let cursor):
      if currentState.feedFetchEnded {
        return .empty()
      }
      return fetchFeedData(cursor: cursor, limit: 10)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .feedLoadEnded(let nextCursor, let feedData):
      newState.feedData = feedData
      newState.nextCursor = nextCursor
    case .feedFetchFailed(let errorMessage):
      newState.feedErrorMessage = errorMessage
    case .feedReachEnd(let feedData):
      newState.feedData = feedData
      newState.feedFetchEnded = true
    }
    
    return newState
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
          id: feed.recordID,
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
  
  private func fetchFeedData(memberId: Int? = nil, cursor: String?, limit: Int) -> Observable<Mutation> {
    return fetchFeedUseCase.execute(memberId: memberId, cursor: cursor, limit: limit)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, feedModel -> Observable<Mutation> in
        let cursor = feedModel.nextCursor
        return owner.convertFeedModel(feedList: GlobalState.shared.feedList.value)
          .map { feedData in
            if let cursor {
              return Mutation.feedLoadEnded(nextCursor: cursor, feedData: feedData)
            } else {
              return Mutation.feedReachEnd(feedData: feedData)
            }
          }
      }
      .catch { error in
        return .just(Mutation.feedFetchFailed(error: error.localizedDescription))
      }
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
