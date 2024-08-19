//
//  ProfileInfoUseCase.swift
//  MyPageDomain
//
//  Created by Jiyeon on 8/19/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol ProfileInfoUseCase {
  func execute() -> Single<ProfileInfo>
}
