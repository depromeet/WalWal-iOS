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
  private let fetchSingleFeedUseCase: FetchSingleFeedUseCase
  private let memberId: Int
  private var isOtherFeed: Bool
  
  public init(
    coordinator: any MyPageCoordinator,
    fetchUserFeedUseCase: FetchUserFeedUseCase,
    fetchSingleFeedUseCase: FetchSingleFeedUseCase,
    memberId: Int
  ) {
    self.isOtherFeed = memberId != GlobalState.shared.profileInfo.value.memberId
    self.memberId = memberId
    
    self.fetchUserFeedUseCase = fetchUserFeedUseCase
    self.fetchSingleFeedUseCase = fetchSingleFeedUseCase
    
    self.initialState = State(memberId: memberId)
    self.coordinator = coordinator
  }
  
  public func transform(action: Observable<Action>) -> Observable<Action> {
  
    let initialLoadAction = Observable.just(
      Action.loadFeed(memberId: memberId, cursorDate: nil)
    )
    
    return Observable.merge(action, initialLoadAction)
  }
  
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadFeed(let memberId, let cursorDate):
      if currentState.feedFetchEnded {
        return .empty()
      } else if isOtherFeed {
        return fetchmemberFeedData(memberId: memberId, cursor: cursorDate, limit: 30)
      }
      return fetchFeedData(memberId: memberId, cursor: cursorDate, limit: 30)
    case .tapBackButton:
      return .just(Mutation.moveToBack)
    case let .isHiddenTabBar(isHidden):
      return configTabBar(isHidden)
    case let .commentTapped(recordId: recordId):
      return .just(.moveToComment(recordId: recordId))
    case .refreshFeedData(recordId: let recordId):
      return fetchUpdatedFeedAt(recordId: recordId)
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
      coordinator.popViewController(animated: true)
    case let .moveToComment(recordId: recordId):
      coordinator.destination.accept(.showCommentView(recordId: recordId)) 
    case .updateFeed(record: let record):
      print(record)
      if let record {
        newState.updatedFeed = record
      }
    }
    
    return newState
  }
}

extension RecordDetailReactorImp {
  
  private func configTabBar(_ isHidden: Bool) -> Observable<Mutation> {
    guard let tabBarViewController = coordinator.navigationController.tabBarController as? WalWalTabBarViewController else {
      return .never()
    }
    if isHidden {
      tabBarViewController.hideCustomTabBar()
    } else {
      tabBarViewController.showCustomTabBar()
    }
    return .never()
  }
  
  private func fetchFeedData(memberId: Int, cursor: String?, limit: Int) -> Observable<Mutation> {
    return fetchUserFeedUseCase.execute(memberId: memberId, cursor: cursor, limit: limit, isProfileFeed: false)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, feedModel -> Observable<Mutation> in
        let cursor = feedModel.nextCursor
        return owner.convertGlobaltoFeedModel(feedList: feedModel.list)
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
  
  private func fetchmemberFeedData(memberId: Int, cursor: String?, limit: Int) -> Observable<Mutation> {
    return fetchUserFeedUseCase.execute(memberId: memberId, cursor: cursor, limit: limit, isProfileFeed: true)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, userFeed in
        let cursor = userFeed.nextCursor
        return owner.convertRawFeedtoFeedModel(feedList: userFeed.list)
          .map { feedData in
            if let cursor {
              return Mutation.fetchUseFeed(memberId: memberId, nextCursor: cursor, newRecord: feedData)
            } else {
              return Mutation.userFeedReachEnd(newRecord: feedData)
            }
          }
      }
      .catch{ error in
        return .just(Mutation.userFeedFetchFailed(errorMessage: error.localizedDescription))}
  }
  
  private func fetchUpdatedFeedAt(recordId: Int) -> Observable<Mutation> {
    return fetchSingleFeedUseCase.execute(recordId: recordId)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, Singlefeed -> Observable<Mutation> in
        return owner.convertGlobaltoFeedModel(feedList: [Singlefeed])
          .withUnretained(self)
          .flatMap { owner, feed -> Observable<Mutation> in
            return .just(.updateFeed(record: feed.first))
          }
      }
  }
  
  
  private func convertRawFeedtoFeedModel(feedList: [FeedListModel]) -> Observable<[WalWalFeedModel]> {
    let feedObservables = feedList.map { feed -> Observable<WalWalFeedModel?> in
      return Observable.zip(
        convertImage(imageURL: feed.missionRecordImageURL),
        convertImage(imageURL: feed.authorProfileImageURL)
      )
        .map({ missionRecordImage, authorProfileImage in
          let profileDefault = authorProfileImage ?? ResourceKitAsset.Assets.yellowDog.image
          return WalWalFeedModel(
            recordId: feed.missionRecordID,
            authorId: feed.authorID,
            date: feed.createdDate,
            nickname: feed.authorNickName,
            missionTitle: feed.missionTitle,
            profileImage: authorProfileImage,
            missionImage: missionRecordImage,
            boostCount: feed.totalBoostCount,
            commentCount: feed.totalCommentCount,
            contents: feed.content ?? ""
          )
        })
    }
    
    return Observable.zip(feedObservables)
      .map { $0.compactMap { $0 } }
  }
  
  private func convertGlobaltoFeedModel(feedList: [FeedListModel]) -> Observable<[WalWalFeedModel]> {
    let feedObservables = feedList.map { feed -> Observable<WalWalFeedModel?> in
      return Observable.zip(
        convertImage(imageURL: feed.missionRecordImageURL),
        convertImage(imageURL: feed.authorProfileImageURL)
      )
      .map { missionImage, profileImage in
        let profileImageOrDefault = profileImage ?? ResourceKitAsset.Assets.yellowDog.image
        return WalWalFeedModel(
          recordId: feed.missionRecordID,
          authorId: feed.authorID,
          date: feed.createdDate,
          nickname: feed.authorNickName,
          missionTitle: feed.missionTitle,
          profileImage: profileImageOrDefault,
          missionImage: missionImage,
          boostCount: feed.totalBoostCount,
          commentCount: feed.totalCommentCount,
          contents: feed.content ?? ""
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
    } else if let cachedImage = GlobalState.shared.imageStore.object(forKey: imageURL as NSString)  {
      return .just(cachedImage)
    } else {
      return GlobalState.shared.downloadAndCacheImage(for: imageURL)
        .map { _ in
          GlobalState.shared.imageStore.object(forKey: imageURL as NSString) 
        }
    }
  }
}
