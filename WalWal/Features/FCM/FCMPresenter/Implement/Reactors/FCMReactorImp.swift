//
//  FCMReactorImp.swift
//
//  FCM
//
//  Created by 이지희
//

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
  
  public init(
    coordinator: any FCMCoordinator,
    fetchFCMListUseCase: FetchFCMListUseCase,
    fcmListUseCase: FCMListUseCase,
    readFCMItemUseCase: ReadFCMItemUseCase
  ) {
    self.coordinator = coordinator
    self.initialState = State()
    self.fetchFCMListUseCase = fetchFCMListUseCase
    self.fcmListUseCase = fcmListUseCase
    self.readFCMItemUseCase = readFCMItemUseCase
  }
  
  public func transform(action: Observable<Action>) -> Observable<Action> {
    let loadFCMList = Observable.just(Action.loadFCMList)
    return Observable.merge(action, loadFCMList)
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadFCMList:
      return fetchFCMListUseCase.execute()
        .withUnretained(self)
        .flatMap { owner, data -> Observable<Mutation> in
          return .just(.loadFCMList(data: owner.separateDataByDate(data: data)))
        }
    case .refreshList:
      return .concat([
        fetchFCMListData(),
        .just(.stopRefreshControl)
      ])
    case let .selectItem(item):
      return readFCMItem(item: item)
        .flatMap {
          self.moveOtherTab(type: item.type, recordId: item.recordID)
        }
    case let .updateItem(index):
      return .just(.updateItem(index: index))
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
    case let .moveFeed(recordId):
      print(recordId ?? "recordId 없음")
    case let .updateItem(index):
      newState.listData[index.section].items[index.row].isRead = true
    }
    return newState
  }
}

extension FCMReactorImp {
  
  /// 알림 탭 시 화면 이동 요청
  private func moveOtherTab(type: FCMTypes, recordId: Int?) -> Observable<Mutation> {
    if type == .mission {
      return  .just(.moveMission)
    } else {
      return .just(.moveFeed(recordId: recordId))
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
  
  
  private func fetchFCMListData() -> Observable<Mutation> {
    /// 기존 데이터 날림
    GlobalState.shared.fcmList.accept([])
    
    return refreshFCMListData(cursor: nil, limit: 10)
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.fetchFCMListUseCase.execute()
      }
      .flatMap { data -> Observable<Mutation> in
        return .just(.loadFCMList(data: self.separateDataByDate(data: data)))
      }
    
  }
  
  /// FCM List 재요청
  private func refreshFCMListData(cursor: String?, limit: Int) -> Observable<Void> {
    return fcmListUseCase.execute(cursor: cursor, limit: limit)
      .asObservable()
      .flatMap { data -> Observable<Void> in
        if let nextCursor = data.nextCursor {
          return self.refreshFCMListData(cursor: nextCursor, limit: limit)
        } else {
          return .just(Void())
        }
      }
  }
  
  /// 데이터  이전알림 구분 메서드
  private func separateDataByDate(data: [FCMItemModel]) -> [FCMSectionModel] {
    var lastData = data
    let today = lastData.filter { $0.createdAt.isWithin24Hours(format: .fullISO8601) }
    lastData.removeAll { $0.createdAt.isWithin24Hours(format: .fullISO8601) }
    let section = [
      FCMSectionModel(section: 0, items: today),
      FCMSectionModel(section: 1, items: lastData)
    ]
    return section
  }
}
