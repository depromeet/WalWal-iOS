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

import BaseCoordinator
import AppCoordinator
import AppCoordinatorImp
import SampleAppCoordinator
import SampleAppCoordinatorImp
import SampleAuthCoordinator
import SampleAuthCoordinatorImp
import SampleHomeCoordinator
import SampleHomeCoordinatorImp

import SplashData
import SplashDataImp
import SplashDomain
import SplashDomainImp
import SplashPresenter
import SplashPresenterImp

import SampleData
import SampleDataImp
import SampleDomain
import SampleDomainImp
import SamplePresenter
import SamplePresenterImp

public class DependencyFactoryImp: DependencyFactory {
  
  public init() {
    
  }
  
  // MARK: - 추가되는 Coordinator에 따라 Dependency를 생성 및 주입하는 함수의 구현부를 작성해주새요
  
  public func makeSampleAppCoordinator(
    navigationController: UINavigationController
  ) -> any SampleAppCoordinator {
    return SampleAppCoordinatorImp(navigationController: navigationController, parentCoordinator: nil, dependencyFactory: self)
  }
  
  public func makeSampleAuthCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any SampleAuthCoordinator {
    return SampleAuthCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      dependencyFactory: self
    )
  }
  
  public func makeSampleHomeCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any SampleHomeCoordinator {
      return SampleHomeCoordinatorImp(
        navigationController: navigationController,
        parentCoordinator: parentCoordinator,
        dependencyFactory: self
      )
    }
  
  public func makeAppCoordinator(navigationController: UINavigationController) -> any AppCoordinator {
    return AppCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: nil,
      dependencyFactory: self
    )
  }
  
  // MARK: - 추가되는 Feature에 따라 Data Dependency를 생성 및 주입하는 함수의 구현부를 작성해주세요.
  
  private let networkService = NetworkService()
  
  public func makeSampleAuthData() -> SampleAuthRepository {
    return SampleAuthRepositoryImpl(networkService: networkService)
  }
  
  // MARK: - 추가되는 Feature에 따라 Domain Dependency를 생성 및 주입하는 함수의 구현부를 작성해주세요.
  
  public func makeSampleSignInUsecase() -> SampleSignInUseCase {
    return SignInUseCaseImpl(sampleAuthRepository: makeSampleAuthData())
  }
  
  public func makeSampleSignUpUsecase() -> SampleSignUpUseCase {
    return SignUpUseCaseImpl(sampleAuthRepository: makeSampleAuthData())
  }
  
  // MARK: - 추가되는 Feature에 따라 Presenter Dependency를 생성 및 주입하는 함수의 구현부를 작성해주세요.
  
  public func makeSampleReactor(coordinator: any SampleAppCoordinator) -> any SampleReactor {
    let sampleSignInUseCase = makeSampleSignInUsecase()
    let sampleSignUpUseCase = makeSampleSignUpUsecase()
    return SampleReactorImp(
      coordinator: coordinator,
      sampleSignInUsecase: sampleSignInUseCase,
      sampleSignUpUsecase: sampleSignUpUseCase
    )
  }
  
  public func makeSplashReactor(coordinator: any AppCoordinator) -> any SplashReactor {
    return SplashReactorImp(coordinator: coordinator)
  }
  
  public func makeSampleViewController<T: SampleReactor>(reactor: T) -> any SampleViewController {
    return SampleViewControllerImp(reactor: reactor)
  }
  
  public func makeSplashViewController<T: SplashReactor>(reactor: T) -> any SplashViewController {
    return SplashViewControllerImp(reactor: reactor)
  }
}
