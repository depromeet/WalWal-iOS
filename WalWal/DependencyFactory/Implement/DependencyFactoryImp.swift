//
//  DependencyFactoryImp.swift
//  DependencyFactory
//
//  Created by 조용인 on 7/10/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//
import UIKit

import DependencyFactory

// MARK: - 추가되는 Feature에 따라 import되는 Interface와 Implement를 작성해주세요.

/// (이곳은 Interface와 Implement 동시에 의존성을 갖습니다.)
/// Ex.
/*
import WalWalNetwork
import WalWalNetworkImp

import AuthDomain
import AuthDomainImp

import AuthData
import AuthDataImp

public class DependencyFactoryImp: DependencyFactory {
  
  // MARK: - 추가되는 Feature에 따라 Dependency를 생성 및 주입하는 함수의 구현부를 작성해주세요.
  
  private let networkService = NetworkService()
  
  // MARK: - Data Injection
  
  public func injectAuthData() -> AuthDataRepository {
    return AuthDataRepositoryImpl(networkService: networkService)
  }
  
  // MARK: - Domain Injection
  
  public func injectSignInUsecase() -> SignInUseCase {
    return SignInUseCaseImpl(authRepository: injectAuthData())
  }
  
  public func injectSignUpUsecase() -> SignUpUseCase {
    return SignUpUseCaseImpl(authRepository: injectAuthData())
  }
}
*/
