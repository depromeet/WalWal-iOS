//
//  FetchFCMListUseCase.swift
//  FCMDomain
//
//  Created by Jiyeon on 9/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState

import RxSwift

public protocol FetchFCMListUseCase {
  func execute() -> Observable<[FCMItemModel]>
}
