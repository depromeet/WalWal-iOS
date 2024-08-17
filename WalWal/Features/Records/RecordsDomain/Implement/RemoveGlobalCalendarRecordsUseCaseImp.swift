//
//  RemoveGlobalCalendarRecordsUseCaseImp.swift
//  RecordsDomainImp
//
//  Created by 조용인 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState
import RecordsDomain

import RxSwift

public final class RemoveGlobalCalendarRecordsUseCaseImp: RemoveGlobalCalendarRecordsUseCase {
  
  public init() {}
  
  public func execute() -> Single<Void> {
    return Single.create { observer in
      GlobalState.shared.updateCalendarRecord(with: [])
      observer(.success(()))
      return Disposables.create()
    }
  }
}
