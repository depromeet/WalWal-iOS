//
//  FetchWalWalCalendarModelsUseCase.swift
//  MyPageDomain
//
//  Created by 조용인 on 8/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import GlobalState

import RxSwift

public protocol FetchWalWalCalendarModelsUseCase {
  func execute() -> Observable<[GlobalMissonRecordListModel]>
}
