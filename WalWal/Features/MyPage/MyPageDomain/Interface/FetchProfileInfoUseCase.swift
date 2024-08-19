//
//  FetchProfileInfoUseCase.swift
//  MyPageDomainImp
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState

import RxSwift

public protocol FetchProfileInfoUseCase {
  func execute() -> Observable<GlobalProfileModel>
}
