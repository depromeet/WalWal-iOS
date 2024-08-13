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
}

public enum MyPageReactorMutation {
  case setSelectedCalendarItem(WalWalCalendarModel)
  case moveToSettingView
}

public struct MyPageReactorState {
  public init() { }
  public var selectedDate: WalWalCalendarModel = .init(imageId: "", date: "", imageData: .init())
}

public protocol MyPageReactor: Reactor where Action == MyPageReactorAction, Mutation == MyPageReactorMutation, State == MyPageReactorState {
  
  var coordinator: any MyPageCoordinator { get }
  
  init(
    coordinator: any MyPageCoordinator
  )
}
