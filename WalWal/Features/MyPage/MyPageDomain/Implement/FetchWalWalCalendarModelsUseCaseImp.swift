//
//  FetchWalWalCalendarModelsUseCaseImp.swift
//  MyPageDomainImp
//
//  Created by 조용인 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import GlobalState
import MyPageDomain

import RxSwift

public final class FetchWalWalCalendarModelsUseCaseImp: FetchWalWalCalendarModelsUseCase {
    private let globalState: GlobalState
    
    public init(globalState: GlobalState = .shared) {
        self.globalState = globalState
    }
    
    public func execute() -> Observable<[GlobalMissonRecordListModel]> {
        return Observable.just(globalState.calendarRecords.value)
    }
}
