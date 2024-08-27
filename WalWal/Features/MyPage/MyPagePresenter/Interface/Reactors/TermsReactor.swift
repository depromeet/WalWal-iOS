//
//  TermsReactor.swift
//  MyPagePresenter
//
//  Created by Jiyeon on 8/27/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import MyPageCoordinator

import ReactorKit

public enum TermsReactorAction {
  case close
}
public enum TermsReactorMutation {
  case close
}

public struct TermsReactorState {
  public init() { }
}

public protocol TermsReactor: Reactor where Action == TermsReactorAction,
                                              Mutation == TermsReactorMutation,
                                            State == TermsReactorState {
  var coordinator: any MyPageCoordinator { get }
  init(coordinator: any MyPageCoordinator)
}
