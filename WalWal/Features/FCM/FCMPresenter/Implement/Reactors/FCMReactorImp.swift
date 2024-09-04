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
  
  public init(
    coordinator: any FCMCoordinator,
    fetchFCMListUseCase: FetchFCMListUseCase,
    fcmListUseCase: FCMListUseCase
  ) {
    self.coordinator = coordinator
    self.initialState = State()
    self.fetchFCMListUseCase = fetchFCMListUseCase
    self.fcmListUseCase = fcmListUseCase
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
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .loadFCMList(data):
      newState.listData = data
    case .stopRefreshControl:
      newState.stopRefreshControl = false
    }
    return newState
  }
}

extension FCMReactorImp {
  
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
