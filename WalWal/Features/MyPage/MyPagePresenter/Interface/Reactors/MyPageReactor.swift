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

import ReactorKit
import RxSwift

public enum MyPageReactorAction {
  case didSelectCalendarItem(WalWalCalendarModel)
  case didTapSettingButton
  case didTapEditButton
  case loadCalendarData
}

public enum MyPageReactorMutation {
  case setSelectedCalendarItem(WalWalCalendarModel)
  case setCalendarData([WalWalCalendarModel]) // 캘린더 데이터를 설정하는 뮤테이션 추가
  case moveToSettingView
  case moveToEditView
}

public struct MyPageReactorState {
  public init() { }
  public var selectedDate: WalWalCalendarModel = .init(imageId: 0, date: "", image: nil)
  public var calendarData: [WalWalCalendarModel] = [] // 캘린더 데이터를 저장할 상태 추가
}

public protocol MyPageReactor: Reactor where Action == MyPageReactorAction, Mutation == MyPageReactorMutation, State == MyPageReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator,
    fetchWalWalCalendarModelsUseCase: FetchWalWalCalendarModelsUseCase,
    profileInfoUseCase: ProfileInfoUseCase
  )
}
