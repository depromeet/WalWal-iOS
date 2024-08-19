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

import RxSwift

public final class MemberInfoUseCaseImp: MembersInfoUseCase {
  private let memberRepository: MembersRepository
  
  public init(memberRepository: MembersRepository) {
    self.memberRepository = memberRepository
  }
  
  public func execute() -> Single<MemeberInfo> {
    return memberRepository.profileInfo()
      .map {
        let profile = MemeberInfo(dto: $0)
        profile.saveToGlobalState()
        return profile
      }
      .asObservable()
      .asSingle()
  }
  
}
