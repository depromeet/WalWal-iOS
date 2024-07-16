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

import SampleAppCoordinator
import SampleAppCoordinatorImp
import SampleAuthCoordinator
import SampleAuthCoordinatorImp
import SampleHomeCoordinator
import SampleHomeCoordinatorImp

import SampleData
import SampleDataImp
import SampleDomain
import SampleDomainImp

import SamplePresenterReactor
import SamplePresenterView

public class DependencyFactoryImp: DependencyFactory {
  
  // MARK: - 추가되는 Coordinator에 따라 Dependency를 생성 및 주입하는 함수의 구현부를 작성해주새요
  
  public func makeSampleAppCoordinator<T: SampleAppCoordinator>(
    navigationController: UINavigationController
  ) -> T? {
    return SampleAppCoordinatorImp(navigationController: navigationController, parentCoordinator: nil, dependencyFactory: self) as? T
  }
  
  public func makeSampleAuthCoordinator<T: SampleAuthCoordinator, U: SampleAppCoordinator>(
    navigationController: UINavigationController,
    parentCoordinator: U
  ) -> T? {
    return SampleAuthCoordinatorImp(navigationController: navigationController, parentCoordinator: parentCoordinator, dependencyFactory: self) as? T
  }
  
  public func makeSampleHomeCoordinator<T: SampleHomeCoordinator, U: SampleAppCoordinator>(
    navigationController: UINavigationController,
    parentCoordinator: U
  ) -> T? {
    return SampleHomeCoordinatorImp(navigationController: navigationController, parentCoordinator: parentCoordinator, dependencyFactory: self) as? T
  }
  
  // MARK: - 추가되는 Feature에 따라 Dependency를 생성 및 주입하는 함수의 구현부를 작성해주세요.
  
  private let networkService = NetworkService()
  
  // MARK: - Make Data
  
  public func makeSampleAuthData() -> SampleAuthRepository {
    return SampleAuthRepositoryImpl(networkService: networkService)
  }
  
  // MARK: - Make Domain
  
  public func makeSampleSignInUsecase() -> SampleSignInUseCase {
    return SignInUseCaseImpl(sampleAuthRepository: makeSampleAuthData())
  }
  
  public func makeSampleSignUpUsecase() -> SampleSignUpUseCase {
    return SignUpUseCaseImpl(sampleAuthRepository: makeSampleAuthData())
  }
  
  // MARK: - Make Presenter
  
  public func makeSampleAuthReactor<T: SampleAuthCoordinator>(coordinator: T) -> SampleReactor {
    let sampleSignInUseCase = makeSampleSignInUsecase()
    let sampleSignUpUseCase = makeSampleSignUpUsecase()
    return SampleReactor(coordinator: coordinator, sampleSignInUsecase: sampleSignInUseCase, sampleSignUpUsecase: sampleSignUpUseCase)
  }
  
  public func makeSampleAuthViewController(reactor: SampleReactor) -> SampleViewController {
    return makeSampleAuthViewController(reactor: reactor)
  }
  
}
