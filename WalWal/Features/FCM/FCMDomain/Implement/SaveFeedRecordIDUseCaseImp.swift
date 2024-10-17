//
//  SaveFeedRecordIDUseCaseImp.swift
//  FCMDomainImp
//
//  Created by Jiyeon on 9/5/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState
import FCMDomain

import RxSwift

public final class SaveFeedRecordIDUseCaseImp: SaveFeedRecordIDUseCase {
  public init() { }
  
  public func execute(recordId: Int?, commentId: Int?) -> Observable<Void> {
    GlobalState.shared.updateRecordId(recordId, commentId: commentId)
    return .just(())
  }
}
