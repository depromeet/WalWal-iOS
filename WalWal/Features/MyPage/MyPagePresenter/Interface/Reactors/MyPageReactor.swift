//
//  MyPageReactor.swift
//
//  MyPage
//
//  Created by 조용인
//

import MyPageDomain
import MyPageCoordinator
import DesignSystem
import MembersDomain
import RecordsDomain
import FeedDomain

import ReactorKit
import RxSwift

public enum MyPageReactorAction {
  case didSelectCalendarItem(memberInfo: MemberModel, calendar: WalWalCalendarModel)
  case didTapSettingButton
  case didTapEditButton
  case loadCalendarData
  case loadProfileInfo
  case loadMemberProfileInfo(memberId: Int)
  case loadMemberCalendar(memberId: Int)
  case loadMissionCount(memberId: Int)
  case didTapBackButton
}

public enum MyPageReactorMutation {
  case setSelectedCalendarItem(WalWalCalendarModel)
  case setCalendarData([WalWalCalendarModel]) // 캘린더 데이터를 설정하는 뮤테이션 추가
  case moveToSettingView
  case moveToRecordDetail(memberInfo: MemberModel, calendar: WalWalCalendarModel)
  case moveToEditView(data: MemberModel)
  case profileInfo(data: MemberModel)
  case setMissionCount(missionCount: Int)
  case moveToBack
}

public struct MyPageReactorState {
  public init() { }
  public var selectedDate: WalWalCalendarModel = .init(recordId: 0, date: "", image: nil)
  public var calendarData: [WalWalCalendarModel] = [] // 캘린더 데이터를 저장할 상태 추가
  public var profileData: MemberModel? = nil
  public var missionCount: Int = 0
}

public protocol MyPageReactor: Reactor where Action == MyPageReactorAction, Mutation == MyPageReactorMutation, State == MyPageReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator,
    fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase,
    fetchMemberInfoUseCase: FetchMemberInfoUseCase,
    checkCompletedTotalRecordsUseCase: CheckCompletedTotalRecordsUseCase,
    checkCalendarRecordsUseCase: CheckCalendarRecordsUseCase,
    memberProfileInfoUseCase: MemberInfoUseCase,
    memberId: Int?
  )
}
