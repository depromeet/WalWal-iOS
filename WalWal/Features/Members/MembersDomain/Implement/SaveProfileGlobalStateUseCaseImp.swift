//
//  SaveProfileGlobalStateUseCaseImp.swift
//  MembersDomainImp
//
//  Created by Jiyeon on 8/22/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import GlobalState
import MembersDomain

public class SaveProfileGlobalStateUseCaseImp: SaveProfileGlobalStateUseCase {
  
  public init() { }
  public func execute(
    memberInfo: MemeberInfo,
    globalState: GlobalState
  ) {
      let globalProfile = GlobalProfileModel(
        memberId: memberInfo.memberId, nickname: memberInfo.nickname,
        profileURL: memberInfo.profileURL,
        raisePet: memberInfo.raisePet
      )
      globalState.updateProfileInfo(data: globalProfile)
    
  }
}
