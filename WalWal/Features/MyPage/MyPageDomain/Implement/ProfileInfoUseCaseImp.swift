//
//  ProfileInfoUseCaseImp.swift
//  MyPageDomainImp
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation
import MyPageDomain
import MyPageData

import RxSwift

public final class ProfileInfoUseCaseImp: ProfileInfoUseCase {
  private let mypageRepository: MyPageRepository
  
  public init(mypageRepository: MyPageRepository) {
    self.mypageRepository = mypageRepository
  }
  
  public func execute() -> Single<ProfileInfo> {
    return mypageRepository.profileInfo()
      .map {
        let profile = ProfileInfo(dto: $0)
        profile.saveToGlobalState()
        return profile
      }
      .asObservable()
      .asSingle()
  }
}
