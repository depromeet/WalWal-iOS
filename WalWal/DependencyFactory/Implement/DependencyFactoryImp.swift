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

import WalWalNetwork
import WalWalNetworkImp

import SampleData
import SampleDataImp
import SampleDomain
import SampleDomainImp

public class DependencyFactoryImp: DependencyFactory {
  
  // MARK: - 추가되는 Feature에 따라 Dependency를 생성 및 주입하는 함수의 구현부를 작성해주세요.
  
  private let networkService = NetworkService()
  
  // MARK: - Data Injection
  
  public func injectSampleAuthData() -> SampleAuthRepository {
    return SampleAuthRepositoryImpl(networkService: networkService)
  }
  
  // MARK: - Domain Injection
  
  public func injectSampleSignInUsecase() -> SampleSignInUseCase {
    return SignInUseCaseImpl(sampleAuthRepository: injectSampleAuthData())
  }
  
  public func injectSampleSignUpUsecase() -> SampleSignUpUseCase {
    return SignUpUseCaseImpl(sampleAuthRepository: injectSampleAuthData())
  }
}
