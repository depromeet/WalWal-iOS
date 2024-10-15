//
//  FCMReactorImp.swift
//
//  FCM
//
//  Created by 이지희
//

import Foundation
import FCMDomain
import FCMPresenter
import FCMCoordinator
import GlobalState

import ReactorKit
import RxSwift

public final class FCMReactorImp: FCMReactor {
  public typealias Action = FCMReactorAction
  public typealias Mutation = FCMReactorMutation
  public typealias State = FCMReactorState
  
  public let initialState: State
  public let coordinator: any FCMCoordinator
  private let fetchFCMListUseCase: FetchFCMListUseCase
  private let fcmListUseCase: FCMListUseCase
  private let readFCMItemUseCase: ReadFCMItemUseCase
  private let saveFeedRecordIDUseCase: SaveFeedRecordIDUseCase
  private let removeGlobalFCMListUseCase: RemoveGlobalFCMListUseCase
  private let saveFCMListGlobalStateUseCase: SaveFCMListGlobalStateUseCase
  
  public init(
    coordinator: any FCMCoordinator,
    fetchFCMListUseCase: FetchFCMListUseCase,
    fcmListUseCase: FCMListUseCase,
    readFCMItemUseCase: ReadFCMItemUseCase,
    saveFeedRecordIDUseCase: SaveFeedRecordIDUseCase,
    removeGlobalFCMListUseCase: RemoveGlobalFCMListUseCase,
    saveFCMListGlobalStateUseCase: SaveFCMListGlobalStateUseCase
  ) {
    self.coordinator = coordinator
    self.initialState = State()
    self.fetchFCMListUseCase = fetchFCMListUseCase
    self.fcmListUseCase = fcmListUseCase
    self.readFCMItemUseCase = readFCMItemUseCase
    self.saveFeedRecordIDUseCase = saveFeedRecordIDUseCase
    self.removeGlobalFCMListUseCase = removeGlobalFCMListUseCase
    self.saveFCMListGlobalStateUseCase = saveFCMListGlobalStateUseCase
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .loadFCMList(cursor, limit):
      return fetchFCMListData(cursor: cursor, limit: limit)
    case .refreshList:
      return refreshFCMListData()
    case let .selectItem(item):
      return selectedItemAction(item: item)
    case let .updateItem(index):
      return .just(.updateItem(index: index))
    case let .doubleTap(index):
      let scrollObservable = Observable.just(Mutation.scrollToTop(index == 2))
      let resetTabObservable = Observable.just(Mutation.resetTabEvent)
      return Observable.concat([scrollObservable, resetTabObservable])
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .loadFCMList(data):
      newState.listData = data
    case .stopRefreshControl:
      newState.stopRefreshControl = false
    case .moveMission:
      coordinator.startMission()
    case .moveFeed:
      coordinator.startFeed()
    case let .updateItem(index):
      let item = newState.listData[index.section].items[index.row]
      changeIsReadValue(item: item)
    case let .nextCursor(cursor):
      newState.nextCursor = cursor
    case let .isLastPage(isLast):
      newState.isLastPage = isLast
    case let .isHiddenEdgePage(isHidden):
      newState.isHiddenEdgePage = isHidden
    case let .scrollToTop(isDoubleTapped):
      newState.isDoubleTap = isDoubleTapped
    case .resetTabEvent:
      newState.isDoubleTap = false
    }
    return newState
  }
}

extension FCMReactorImp {
  
  /// FCM 아이템 요청 메서드
  private func fetchFCMListData(cursor: String?, limit: Int) -> Observable<Mutation> {
    return fcmListUseCase.execute(cursor: cursor, limit: limit)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, item -> Observable<Mutation> in
        owner.saveFCMListGlobalState(item: item)
        return .concat([
          owner.loadSavedFCMListData(),
          .just(.nextCursor(cursor: item.nextCursor)),
          .just(.isLastPage(item.nextCursor == nil))
        ])
      }
      .catch { error in
        print(error.localizedDescription)
        return .never()
      }
  }
  
  private func saveFCMListGlobalState(item: FCMListModel) {
    self.saveFCMListGlobalStateUseCase.execute(fcmList: item, globalState: GlobalState.shared)
  }
  
  /// GlobalState에 저장된 FCM list 불러오기
  private func loadSavedFCMListData() -> Observable<Mutation> {
    return fetchFCMListUseCase.execute()
      .withUnretained(self)
      .flatMap { owner, data -> Observable<Mutation> in
        return .concat([
          .just(.isHiddenEdgePage(!data.isEmpty)),
          .just(.loadFCMList(data: owner.separateDataByDate(data: data)))
        ])
      }
  }
  
  /// 알림 선택 시 플로우
  private func selectedItemAction(item: FCMItemModel) -> Observable<Mutation> {
    return readFCMItem(item: item)
      .flatMap {
        let isComment = item.type == .comment || item.type == .recomment
        return self.moveOtherTab(
          type: item.type,
          recordId: item.recordID,
          isComment: isComment
        )
      }
  }
  
  /// 알림 읽었을 때 셀 모델 값 변경 처리
  private func changeIsReadValue(item: FCMItems) {
    switch item {
    case let .fcmItems(reactor):
      reactor.action.onNext(.changeIsReadValue(value: true))
    }
  }
  
  /// 알림 탭 시 화면 이동 요청
  private func moveOtherTab(type: FCMTypes, recordId: Int?, isComment: Bool = false) -> Observable<Mutation> {
    if type == .mission {
      return  .just(.moveMission)
    } else {
      return saveFeedRecordIDUseCase.execute(recordId: recordId, isComment: isComment)
        .flatMap { _ -> Observable<Mutation> in
            .just(.moveFeed)
        }
    }
  }
  
  /// 알림 읽음 처리
  private func readFCMItem(item: FCMItemModel) -> Observable<Void> {
    guard !item.isRead else { return .just(Void()) }
    return readFCMItemUseCase.execute(id: item.notificationID)
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<Void> in
        return .just(Void())
      }
      .catch { _ in
        print("읽음 처리 실패")
        return .just(Void())
      }
  }
  
  /// 알림 새로고침
  private func refreshFCMListData() -> Observable<Mutation> {
    return removeGlobalFCMListUseCase.execute()
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ -> Observable<Mutation> in
        return .concat([
          owner.fetchFCMListData(cursor: nil, limit: 10),
          .just(.stopRefreshControl)
        ])
      }
  }
  
  /// 데이터  이전알림 구분 메서드
  private func separateDataByDate(data: [FCMItemModel]) -> [FCMSection] {
    var lastData = data
    let today = lastData
      .filter { $0.createdAt.isWithin24Hours(format: .fullISO8601) }
      .map {
        FCMItems.fcmItems(reactor: FCMCellReactor(state: $0))
      }
    lastData.removeAll { $0.createdAt.isWithin24Hours(format: .fullISO8601) }
    let last = lastData.map {
      return FCMItems.fcmItems(reactor: FCMCellReactor(state: $0))
    }
    
    let section = [
      FCMSection.today(item: today),
      FCMSection.last(item: last)
    ]
    return section
  }
}
