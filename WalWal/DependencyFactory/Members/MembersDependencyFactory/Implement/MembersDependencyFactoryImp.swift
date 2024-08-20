//
//  MembersDependencyFactoryImplement.swift
//
//  Members
//
//  Created by Jiyeon
//

import UIKit
import MembersDependencyFactory
import MembersData
import MembersDataImp
import MembersDomain
import MembersDomainImp
import WalWalNetwork

public class MembersDependencyFactoryImp: MembersDependencyFactory {
  
  public init() { }
  
  public func injectMembersRepository() -> MembersRepository {
    let networkService = NetworkService()
    return MembersRepositoryImp(networkService: networkService)
  }
  public func injectMemberInfoUseCase() -> MemberInfoUseCase {
    return MemberInfoUseCaseImp(memberRepository: injectMembersRepository())
  }
  public func injectFetchMemberInfoUseCase() -> FetchMemberInfoUseCase {
    return FetchMemberInfoUseCaseImp()
  }
  public func injectCheckNicknameUseCase() -> CheckNicknameUseCase {
    return CheckNicknameUseCaseImp(membersRepository: injectMembersRepository())
  }
  public func injectEditProfileUseCase() -> EditProfileUseCase {
    return EditProfileUseCaseImp(membersRepository: injectMembersRepository())
  }
}
