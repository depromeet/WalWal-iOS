//
//  FetchMemberInfoUseCaseImp.swift
//  MembersDomainImp
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState
import MembersDomain

import RxSwift

public final class FetchMemberInfoUseCaseImp: FetchMemberInfoUseCase {
  private let globalState: GlobalState
  
  public init(globalState: GlobalState = .shared) {
    self.globalState = globalState
  }
  public func execute() -> Observable<GlobalProfileModel> {
    return Observable.just(globalState.profileInfo.value)
  }
}
