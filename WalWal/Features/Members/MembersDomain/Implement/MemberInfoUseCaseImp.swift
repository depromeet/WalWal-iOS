//
//  MemberInfoUseCaseImp.swift
//  MembersDomain
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MembersData
import MembersDomain
import GlobalState

import RxSwift

public final class MemberInfoUseCaseImp: MemberInfoUseCase {
  private let memberRepository: MembersRepository
  private let saveProfileGlobalStateUseCase: SaveProfileGlobalStateUseCase
  
  public init(
    memberRepository: MembersRepository,
    saveProfileGlobalStateUseCase: SaveProfileGlobalStateUseCase
  ) {
    self.memberRepository = memberRepository
    self.saveProfileGlobalStateUseCase = saveProfileGlobalStateUseCase
  }
  
  public func execute() -> Single<MemeberInfo> {
    return memberRepository.profileInfo()
      .map { info -> MemeberInfo in
        let profile = MemeberInfo(dto: info)
        self.saveProfileGlobalStateUseCase.execute(memberInfo: profile, globalState: GlobalState.shared)
        return profile
      }
      .asObservable()
      .asSingle()
  }
  
}
