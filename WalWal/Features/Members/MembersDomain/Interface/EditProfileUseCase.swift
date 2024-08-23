//
//  EditProfileUseCase.swift
//  MembersDomain
//
//  Created by Jiyeon on 8/20/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol EditProfileUseCase {
  func execute(nickname: String, profileImage: String) -> Single<Void>
}
