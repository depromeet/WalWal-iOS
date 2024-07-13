//
//  SampleSignInUseCase.swift
//  SampleDomainImp
//
//  Created by 조용인 on 7/13/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol SignInUseCase {
  func execute(id:String, password: String) -> Single<Token>
}

