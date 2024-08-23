//
//  EditProfileUseCaseImp.swift
//  MembersDomainImp
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MembersDomain
import MembersData

import RxSwift

public final class EditProfileUseCaseImp: EditProfileUseCase {
  private let membersRepository: MembersRepository
  
  public init(membersRepository: MembersRepository) {
    self.membersRepository = membersRepository
  }
  
  public func execute(nickname: String, profileImage: String) -> Single<Void> {
    return membersRepository.editProfile(nickname: nickname, profileImage: profileImage)
  }
}
