//
//  SaveProfileGlobalStateUseCase.swift
//  MembersDomain
//
//  Created by Jiyeon on 8/22/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState

public protocol SaveProfileGlobalStateUseCase {
  func execute(
    memberInfo: MemeberInfo,
    globalState: GlobalState
  ) 
}
