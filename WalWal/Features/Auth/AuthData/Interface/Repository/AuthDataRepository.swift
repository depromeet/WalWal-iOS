//
//  AuthDataRepository.swift
//
//  Auth
//
//  Created by 조용인 on .
//

import UIKit

import RxSwift

public protocol AuthDataRepository {
  /// - 기능에 따라서 필요한 함수를 추가해주세요.
  func signUp(nickname: String, profile: Data) -> Single<SignUpDTO>
  func signIn(id: String, password: String) -> Single<SignInDTO>
}

