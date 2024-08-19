//
//  FetchWalWalFeedUseCaseImp.swift
//  FeedDomainImp
//
//  Created by 이지희 on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState
import FeedDomain

import RxSwift

public final class FetchWalWalFeedUseCaseImp: FetchWalWalFeedUseCase {
    private let globalState: GlobalState
    
    public init(globalState: GlobalState = .shared) {
        self.globalState = globalState
    }
    
    public func execute() -> Observable<[GlobalFeedListModel]> {
        return Observable.just(globalState.feedList.value)
    }
}
