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

import ReactorKit
import RxSwift

public final class MyPageReactorImp: MyPageReactor {
  public typealias Action = MyPageReactorAction
  public typealias Mutation = MyPageReactorMutation
  public typealias State = MyPageReactorState
  
  public let initialState: State
  public let coordinator: any MyPageCoordinator
  
  public init(
    coordinator: any MyPageCoordinator
  ) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .didSelectCalendarItem(model):
      return Observable.just(.setSelectedCalendarItem(model))
    case .didTapSettingButton:
      return Observable.just(.moveToSettingView)
    case .didTapEditButton:
      return Observable.just(.moveToEditView)
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case let .setSelectedCalendarItem(date):
      newState.selectedDate = date
      coordinator.destination.accept(.showRecordDetail)
    case .moveToSettingView:
      coordinator.destination.accept(.showProfileSetting)
    case .moveToEditView:
      coordinator.destination.accept(.showProfileEdit)
    }
    return newState
  }
}
