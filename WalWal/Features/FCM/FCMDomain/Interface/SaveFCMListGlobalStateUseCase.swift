//
//  SaveFCMListGlobalStateUseCase.swift
//  FCMDomain
//
//  Created by Jiyeon on 9/2/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState

public protocol SaveFCMListGlobalStateUseCase {
  func execute(
    fcmList: FCMListModel,
    globalState: GlobalState
  )
}
