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

import RecordsDomain

import ReactorKit
import RxSwift

public final class FeedReactorImp: FeedReactor {
  
  public typealias Action = FeedReactorAction
  public typealias Mutation = FeedReactorMutation
  public typealias State = FeedReactorState
  
  public let initialState: State
  public let coordinator: any FeedCoordinator
  
  private let fetchFeedUseCase: FetchFeedUseCase
  private let updateBoostCountUseCase: UpdateBoostCountUseCase
  private let removeGlobalRecordIdUseCase: RemoveGlobalRecordIdUseCase
  private let fetchSingleFeedUseCase: FetchSingleFeedUseCase
  
  private var isLoading: Bool = false
  
  public init(
    coordinator: any FeedCoordinator,
    fetchFeedUseCase: FetchFeedUseCase,
    updateBoostCountUseCase: UpdateBoostCountUseCase,
    removeGlobalRecordIdUseCase: RemoveGlobalRecordIdUseCase,
    fetchSingleFeedUseCase: FetchSingleFeedUseCase
  ) {
    self.coordinator = coordinator
    self.fetchFeedUseCase = fetchFeedUseCase
    self.updateBoostCountUseCase = updateBoostCountUseCase
    self.removeGlobalRecordIdUseCase = removeGlobalRecordIdUseCase
    self.fetchSingleFeedUseCase = fetchSingleFeedUseCase
    
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
    case let .loadFeedData(cursor):
      return loadFeedData(cursor: cursor)
    case let .refresh(cursor):
      return refreshFeedData(cursor: cursor)
    case let .endedBoost(recordId, count):
      return postBoostCount(recordId: recordId, count: count)
        .observe(on: MainScheduler.asyncInstance)
    case .profileTapped(let feedData):
      return .just(.moveToProfile(memberId: feedData.authorId, nickName: feedData.nickname))
    case .checkScrollItem:
      return checkScrollEvent()
    case let .doubleTap(index):
      let scrollObservable = Observable.just(Mutation.scrollToTop(index == 1))
      let resetTabObservable = Observable.just(Mutation.resetTabEvent)
      return Observable.concat([scrollObservable, resetTabObservable])
    case let .menuTapped(recordId):
      return .just(.showMenu(recordId: recordId))
    case let .commentTapped(recordId, writerNickname):
      return .just(.moveToComment(recordId: recordId, writerNickname: writerNickname))
    case .refreshFeedData(recordId: let recordId):
      return fetchUpdatedFeedAt(recordId: recordId)
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
    case .moveToProfile(let memberId, let nickName):
      coordinator.startProfile(memberId: memberId, nickName: nickName)
    case let .scrollToFeedItem(id):
      newState.scrollToFeedItem = id
    case let .scrollToTop(isDoubleTapped):
      newState.isDoubleTap = isDoubleTapped
    case .resetTabEvent:
      newState.isDoubleTap = false
    case let .showMenu(recordId):
      coordinator.destination.accept(.showFeedMenu(recordId: recordId))
    case let .moveToComment(recordId, writerNickname):
      coordinator.destination.accept(.showCommentView(recordId: recordId, writerNickname: writerNickname))
    case let .updateFeed(record: updatedFeed):
      if let updatedFeed {
        newState.updatedFeed = updatedFeed
      }
    }
    return newState
  }
  
}

extension FeedReactorImp {
  
  private func loadFeedData(cursor: String?) -> Observable<Mutation> {
    guard !isLoading && !currentState.feedFetchEnded else {
      return .empty()
    }
    isLoading = true
    return fetchFeedData(cursor: cursor, limit: 10)
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .observe(on: MainScheduler.asyncInstance)
      .do(onCompleted: { [weak self] in
        self?.isLoading = false
      })
  }
  private func refreshFeedData(cursor: String?) -> Observable<Mutation> {
    // refresh도 isLoading 확인 후 처리
    guard !isLoading else {
      return .empty()
    }
    isLoading = true
    let initialFeedData: [WalWalFeedModel] = []
    let nextCursor: String? = nil
    GlobalState.shared.feedList.accept([])
    return Observable.just(.feedLoadEnded(nextCursor: nextCursor, feedData: initialFeedData))
      .concat(fetchFeedData(cursor: cursor, limit: 10))
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
      .observe(on: MainScheduler.asyncInstance)
      .do(onCompleted: { [weak self] in
        self?.isLoading = false
      })
  }
  
  /// 알림 - 피드 넘어왔을 때 스크롤이 넘어가야 하는지 여부
  private func checkScrollEvent() -> Observable<Mutation> {
    return GlobalState.shared.moveToFeedRecord
      .observe(on: MainScheduler.asyncInstance)
      .asObservable()
      .compactMap { $0 }
      .filter { $0.0 != nil }
      .withUnretained(self)
      .map { owner, fcmData -> (Int?, Bool) in
        owner.removeGlobalRecordIdUseCase.execute()
        return fcmData
      }
      .flatMap { id, isComment -> Observable<Mutation> in
        if isComment, let id = id {
          return .concat([
            .just(.scrollToFeedItem(id: id)),
            self.moveToCommentwithWriter(recordId: id)
          ])
        } else {
          return .just(.scrollToFeedItem(id: id))
        }
      }
  }
  
  private func moveToCommentwithWriter(recordId: Int) -> Observable<Mutation> {
    if let item = currentState.feedData.first(where: {$0.recordId == recordId }) {
      return .just(.moveToComment(recordId: recordId, writerNickname: item.nickname))
    } else {
      return .just(.moveToComment(recordId: recordId, writerNickname: ""))
    }
  }
  
  private func fetchFeedData(memberId: Int? = nil, cursor: String?, limit: Int) -> Observable<Mutation> {
    return fetchFeedUseCase.execute(memberId: memberId, cursor: cursor, limit: limit)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, feedModel -> Observable<Mutation> in
        let cursor = feedModel.nextCursor
        // 기존에는 global state에 저장되어 있던 값 사용 -> 네트워크 결과로 나온 list 사용
        return owner.convertFeedModel(feedList: feedModel.list)
          .withUnretained(self)
          .flatMap { owner, feedData -> Observable<Mutation> in
            if let cursor {
              return .just(.feedLoadEnded(nextCursor: cursor, feedData: feedData))
            } else {
              return .just(.feedReachEnd(feedData: feedData))
            }
          }
      }
      .catch { error in
        return .just(Mutation.feedFetchFailed(error: error.localizedDescription))
      }
  }
  
  private func postBoostCount(recordId: Int, count: Int) -> Observable<Mutation> {
    return updateBoostCountUseCase.execute(recordId: recordId, count: count)
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in
        return .never()
      }
  }
  
  private func fetchUpdatedFeedAt(recordId: Int) -> Observable<Mutation> {
    // 여기 특정 피드만 불러오는 걸로 수정 필요
    return fetchSingleFeedUseCase.execute(recordId: recordId)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, singleFeed -> Observable<Mutation> in
        return owner.convertFeedModel(feedList: [singleFeed])
          .withUnretained(self)
          .flatMap { owner, feed -> Observable<Mutation> in
            return .just(.updateFeed(record: feed.first))
          }
      }
  }
  
  // MARK: - Helper
  
  private func convertFeedModel(feedList: [FeedListModel]) -> Observable<[WalWalFeedModel]> {
    let feedObservables = feedList.map { feed -> Observable<WalWalFeedModel> in
      // 이미지 URL로부터 이미지를 비동기적으로 로드
      let missionImageObservable = convertImage(imageURL: feed.missionRecordImageURL)
      let profileImageObservable = convertImage(imageURL: feed.authorProfileImageURL, isSmallImage: true)
      
      return Observable.zip(missionImageObservable, profileImageObservable)
        .flatMap { missionImage, profileImage -> Observable<WalWalFeedModel> in
          // 기본 프로필 이미지 설정
          let profileImageOrDefault = profileImage ?? ResourceKitAsset.Assets.yellowDog.image
          
          // WalWalFeedModel 객체 생성
          let feedModel = WalWalFeedModel(
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
          
          return .just(feedModel)
        }
    }
    
    return Observable.zip(feedObservables)
      .map { $0.compactMap { $0 } }
  }
  
  
  private func convertImage(imageURL: String?, isSmallImage: Bool = false) -> Observable<UIImage?> {
    guard let imageURL = imageURL else {
      return .just(nil)
    }
    
    if let defaultImage = DefaultProfile(rawValue: imageURL) {
      return .just(defaultImage.image) // 기본 이미지 반환
    }
    if let cachedImage = GlobalState.shared.imageStore.object(forKey: imageURL as NSString) {
        return .just(cachedImage)
    }
    
    return GlobalState.shared.downloadAndCacheImage(for: imageURL, isSmallImage: isSmallImage)
        .map { _ in
            return GlobalState.shared.imageStore.object(forKey: imageURL as NSString)
        }
    }
}
