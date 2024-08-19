//
//  MembersDependencyFactoryInterface.swift
//
//  Members
//
//  Created by Jiyeon
//

import UIKit
import MembersData
import MembersDomain


public protocol MembersDependencyFactory {
  
  func injectMembersRepository() -> MembersRepository
  func injectMembersInfoUseCase() -> MembersInfoUseCase
  func injectFetchMemberInfoUseCase() -> FetchMemberInfoUseCase
  
}
