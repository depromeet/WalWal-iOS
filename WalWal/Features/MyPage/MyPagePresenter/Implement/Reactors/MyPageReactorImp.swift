//
//  MyPageReactorImp.swift
//
//  MyPage
//
//  Created by 조용인
//

import UIKit
import MyPageDomain
import MyPagePresenter
import MyPageCoordinator
import GlobalState
import DesignSystem
import Utility

import RecordsDomain
import MembersDomain

import ReactorKit
import RxSwift
import RxRelay

public final class MyPageReactorImp: MyPageReactor {
  public typealias Action = MyPageReactorAction
  public typealias Mutation = MyPageReactorMutation
  public typealias State = MyPageReactorState
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  
  private var memberId: Int?
  
  private let fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase
  private let fetchMemberInfoUseCase: FetchMemberInfoUseCase
  private let checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase
  private let checkCalendarRecordsUseCase: CheckCalendarRecordsUseCase
  
  public init(
    coordinator: any MyPageCoordinator,
    fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase,
    checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase,
    checkCalendarRecordsUseCase: CheckCalendarRecordsUseCase,
    memberId: Int? = GlobalState.shared.profileInfo.value.memberId
  ) {
    self.memberId = memberId
    self.coordinator = coordinator
    self.fetchWalWalCalendarModelsUseCase = fetchWalWalCalendarModelsUseCase
    self.fetchMemberInfoUseCase = fetchMemberInfoUseCase
    self.checkCompletedTotalRecordsUseCase = checkCompletedTotalRecordsUseCase
    self.checkCalendarRecordsUseCase = checkCalendarRecordsUseCase
    self.initialState = State()
  }
  
  /// `transform` 메서드를 사용하여 액션 스트림을 변형합니다.
  public func transform(action: Observable<Action>) -> Observable<Action> {
    let defaultMemberId = GlobalState.shared.profileInfo.value.memberId
    let isOther = !(memberId == GlobalState.shared.profileInfo.value.memberId)
    /// 초기 액션으로 `loadCalendarData`를 추가
    let initialLoadAction = Observable.just(Action.loadCalendarData)
    let initialProfileAction = Observable.just(Action.loadProfileInfo)
    
    let initialLoadMemberCalendar = Observable.just(Action.loadMemberCalendar(memberId: memberId ?? defaultMemberId))
    let initialLoadCount = Observable.just(Action.loadMissionCount(memberId: memberId ?? defaultMemberId))
    /// 기존 액션 스트림과 초기 액션 스트림을 병합
    if isOther {
      return Observable.merge(action, initialLoadCount, initialLoadMemberCalendar)
    } else {
      return Observable.merge(action, initialLoadAction, initialProfileAction)
    }
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didSelectCalendarItem(let member, let calendar):
      return Observable.just(.moveToRecordDetail(memberInfo: member, calendar: calendar))
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
    case .didTapBackButton:
      return Observable.just(.moveToBack)
    case .loadMissionCount(memberId: let memberId):
      return checkCompletedTotalRecordsUseCase.execute(memberId: memberId)
        .asObservable()
        .flatMap { missionCountModel -> Observable<Mutation> in
          print(missionCountModel.totalCount)
          return .just(.setMissionCount(missionCount: missionCountModel.totalCount))
        }
    case .loadMemberCalendar(memberId: let memberId):
      return checkCalendarRecordsUseCase.execute(cursor: "2024-08-01", limit: 30, memberId: memberId)
        .asObservable()
        .flatMap { records -> Observable<[WalWalCalendarModel]> in
          return self.convertToWalWalCalendarModels(from: records.list)
        }
        .map { calendarModels in
          return Mutation.setCalendarData(calendarModels)
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
    case .moveToRecordDetail(let member, let calendar):
      coordinator.destination.accept(.showRecordDetail(
        nickname: member.nickname,
        memberId: member.memberId,
        recordId: calendar.recordId
      ))
    case .moveToBack:
      coordinator.requirefinish()
    case .setMissionCount(let count):
      newState.missionCount = count
    }
    return newState
  }
  
  private func fetchMissionCount(id: Int) {
    
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
  
  private func convertToWalWalCalendarModels(from records: [MissionRecordListModel]) -> Observable<[WalWalCalendarModel]> {
    let imageCacheManager = ImageCacheManager()
    
    let observables = records.map { record -> Observable<WalWalCalendarModel> in
      return imageCacheManager.downloadImage(for: record.imageUrl ?? "")
        .map { image in
          return WalWalCalendarModel(
            recordId: record.recordId,
            date: record.missionDate,
            image: image ?? UIImage()
          )
        }
    }
    
    return Observable.zip(observables)
  }
}
