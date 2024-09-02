//
//  FetchFCMListUseCaseImp.swift
//  FCMDomainImp
//
//  Created by Jiyeon on 9/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState
import FCMDomain

import RxSwift

public final class FetchFCMListUseCaseImp: FetchFCMListUseCase {
  private let globalState: GlobalState
  
  public init(globalState: GlobalState = .shared) {
    self.globalState = globalState
  }
  
  public func execute() -> Observable<[FCMItemModel]> {
    let data = globalState.fcmList.value
    let fcmItems = data.map { FCMItemModel(global: $0) }
    return Observable.just(fcmItems)
  }
}
