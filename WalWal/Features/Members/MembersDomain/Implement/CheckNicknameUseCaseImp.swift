//
//  NicknameCheckUseCase.swift
//  MembersDomainImp
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MembersDomain
import MembersData

import RxSwift

public final class CheckNicknameUseCaseImp: CheckNicknameUseCase {
  private let membersRepository: MembersRepository
  
  public init(membersRepository: MembersRepository) {
    self.membersRepository = membersRepository
  }
  
  public func execute(nickname: String) -> Single<Void> {
    return membersRepository.checkValidNickname(nickname: nickname)
  }
}
