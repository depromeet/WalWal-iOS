//
//  FetchProfileInfoUseCaseImp.swift
//  MyPageDomainImp
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState
import MyPageDomain

import RxSwift

public final class FetchProfileInfoUseCaseImp: FetchProfileInfoUseCase {
  private let globalState: GlobalState
  
  public init(globalState: GlobalState = .shared) {
    self.globalState = globalState
  }
  public func execute() -> Observable<GlobalProfileModel> {
    return Observable.just(globalState.profileInfo.value)
  }
}
