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
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadFeedData(let cursor, let limit):
      return fetchFeedUseCase.excute(cursor: cursor, limit: limit)
        .asObservable()
        .map { feed -> [WalWalFeedModel] in
          self.convertFeedModel(feedList: feed.list)
        }
        .map {
          Mutation.setFeedData($0)
        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setFeedData(feed):
      newState.feedData = feed
    }
    
    return newState
  }
  
  private func convertFeedModel(feedList: [FeedListModel]) -> [WalWalFeedModel]{
    return feedList.compactMap { feed in
      let image = GlobalState.shared.imageStore[feed.missionRecordImageURL]
      return WalWalFeedModel(
        id: feed.missionID,
        date: feed.createdDate,
        nickname: "\(feed.authorID)",
        missionTitle: "\(feed.missionID)",
        profileImage: UIImage(),
        missionImage: image ?? UIImage(),
        boostCount: feed.totalBoostCount)
    }
  }
}
