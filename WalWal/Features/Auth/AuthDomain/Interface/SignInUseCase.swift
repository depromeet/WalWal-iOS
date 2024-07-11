//
//  SignInUseCase.swift
//  AuthDomain
//
//  Created by 조용인 on 7/11/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import Foundation

import RxSwift

public protocol SignInUseCase {
  func execute(id:String, password: String) -> Single<Token>
}

