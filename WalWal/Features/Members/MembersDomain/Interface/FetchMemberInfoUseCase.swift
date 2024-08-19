//
//  FetchMemberInfoUseCase.swift
//  MembersDomain
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState

import RxSwift

public protocol FetchMemberInfoUseCase {
  func execute() -> Observable<GlobalProfileModel>
}
