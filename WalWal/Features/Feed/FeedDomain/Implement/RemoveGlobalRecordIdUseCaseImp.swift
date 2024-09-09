//
//  RemoveGlobalRecordIdUseCaseImp.swift
//  FeedDomainImp
//
//  Created by Jiyeon on 9/9/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import FeedDomain
import GlobalState

import RxSwift

public final class RemoveGlobalRecordIdUseCaseImp: RemoveGlobalRecordIdUseCase {
  public init() { }
  
  public func execute() {
    GlobalState.shared.updateRecordId(nil)
  }
}
