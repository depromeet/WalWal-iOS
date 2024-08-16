//
//  OnboardingReactorImp.swift
//
//  Onboarding
//
//  Created by Jiyeon
//

import OnboardingDomain
import OnboardingPresenter
import OnboardingCoordinator

import ReactorKit
import RxSwift

/// 온보딩 전체 뷰에서 사용되는 Reactor
///
/// 온보딩에서 사용되는 뷰에서 하나의 reactor만 사용되도록 구현하였습니다.
///
/// 전체 뷰가 하나의 플로우로 진행되기 때문에 여러 reactor를 생성할 필요는 없다고 판단하였습니다.
public final class OnboardingReactorImp: OnboardingReactor {
  public typealias Action = OnboardingReactorAction
  public typealias Mutation = OnboardingReactorMutation
  public typealias State = OnboardingReactorState
  
  public let initialState: State
  public let coordinator: any OnboardingCoordinator
  
  public init(
    coordinator: any OnboardingCoordinator
  ) {
    self.coordinator = coordinator
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .nextButtonTapped(flow):
      coordinator.destination.accept(flow)
      return .never()
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    
  }
}
