//
//  RemoveGlobalFCMListUseCaseImp.swift
//  FCMDomainImp
//
//  Created by Jiyeon on 9/5/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FCMDomain
import GlobalState

import RxSwift

public final class RemoveGlobalFCMListUseCaseImp: RemoveGlobalFCMListUseCase {
  
  public init() { }
  
  public func execute() -> Single<Void> {
    return Single.create { observable in
      GlobalState.shared.removeRecords()
      observable(.success(()))
      return  Disposables.create()
    }
  }
}
