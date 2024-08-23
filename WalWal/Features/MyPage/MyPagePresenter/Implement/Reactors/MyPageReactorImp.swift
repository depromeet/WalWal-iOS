//
//  MyPageReactorImp.swift
//
//  MyPage
//
//  Created by 조용인
//

import MyPageDomain
import MyPagePresenter
import MyPageCoordinator
import GlobalState
import DesignSystem
import MembersDomain

import ReactorKit
import RxSwift

public final class MyPageReactorImp: MyPageReactor {
  public typealias Action = MyPageReactorAction
  public typealias Mutation = MyPageReactorMutation
  public typealias State = MyPageReactorState
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  
  private let fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase
  private let fetchMemberInfoUseCase: FetchMemberInfoUseCase
  
  public init(
    coordinator: any MyPageCoordinator,
    fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase
  ) {
    self.coordinator = coordinator
    self.fetchWalWalCalendarModelsUseCase = fetchWalWalCalendarModelsUseCase
    self.fetchMemberInfoUseCase = fetchMemberInfoUseCase
    self.initialState = State()
  }
  
  /// `transform` 메서드를 사용하여 액션 스트림을 변형합니다.
  public func transform(action: Observable<Action>) -> Observable<Action> {
    /// 초기 액션으로 `loadCalendarData`를 추가
    let initialLoadAction = Observable.just(Action.loadCalendarData)
    let initialProfileAction = Observable.just(Action.loadProfileInfo)
    /// 기존 액션 스트림과 초기 액션 스트림을 병합
    return Observable.merge(action, initialLoadAction, initialProfileAction)
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didSelectCalendarItem(let member, let date):
      return Observable.just(.moveToRecordDetail(memberInfo: member, cursor: date))
    case .didTapSettingButton:
      return Observable.just(.moveToSettingView)
    case .didTapEditButton:
      return fetchMemberInfoUseCase.execute()
        .map { MemberModel(global: $0) }
        .flatMap {
          Observable.just(.moveToEditView(data: $0))
        }
    case .loadCalendarData:
      return fetchWalWalCalendarModelsUseCase.execute()
        .map { records -> [WalWalCalendarModel] in
          self.convertToWalWalCalendarModels(from: records)
        }
        .map { Mutation.setCalendarData($0) }
    case .loadProfileInfo:
      return fetchMemberInfoUseCase.execute()
        .map { MemberModel(global: $0) }
        .asObservable()
        .flatMap { info -> Observable<Mutation> in
          return .just(.profileInfo(data: info))
        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setSelectedCalendarItem(calendar):
      newState.selectedDate = calendar
    case let .setCalendarData(calendarData):
      newState.calendarData = calendarData
    case .moveToSettingView:
      coordinator.destination.accept(.showProfileSetting)
    case let .moveToEditView(info):
      coordinator.destination.accept(.showProfileEdit(
        nickname: info.nickname,
        defaultProfile: info.defaultImageName,
        selectImage: info.profileImage,
        raisePet: info.raisePet
      ))
    case let .profileInfo(data):
      newState.profileData = data
    case .moveToRecordDetail(let member, let cursor):
      coordinator.destination.accept(.showRecordDetail(
        nickname: member.nickname,
        memberId: member.memberId
      ))
    }
    return newState
  }
}

extension MyPageReactorImp {
  private func convertToWalWalCalendarModels(from records: [GlobalMissonRecordListModel]) -> [WalWalCalendarModel] {
    return records.compactMap { record in
      let image = GlobalState.shared.imageStore[record.imageUrl]
      return WalWalCalendarModel(
        recordId: record.recordId,
        date: record.missionDate,
        image: image
      )
    }
  }
}
