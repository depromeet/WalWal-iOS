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
  func injectMemberInfoUseCase() -> MemberInfoUseCase
  func injectFetchMemberInfoUseCase() -> FetchMemberInfoUseCase
  
}
