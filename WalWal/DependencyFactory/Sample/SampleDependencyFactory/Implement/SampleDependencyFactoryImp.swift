//
//  SampleDependencyFactoryImplement.swift
//
//  Sample
//
//  Created by 조용인
//

import UIKit
import SampleDependencyFactory

import WalWalNetwork

import BaseCoordinator
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
import SamplePresenter
import SamplePresenterImp


public class SampleDependencyFactoryImp: SampleDependencyFactory {
  
  public init() {
    
  }
  
  public func makeSampleAppCoordinator(navigationController: UINavigationController) -> any SampleAppCoordinator {
    return SampleAppCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: nil,
      dependencyFactory: self
    )
  }
  
  public func makeSampleAuthCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator
  ) -> any SampleAuthCoordinator {
    return SampleAuthCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      dependencyFactory: self
    )
  }

  public func makeSampleHomeCoordinator(
    navigationController: UINavigationController,
    parentCoordinator: any BaseCoordinator
  ) -> any SampleHomeCoordinator {
    return SampleHomeCoordinatorImp(
      navigationController: navigationController,
      parentCoordinator: parentCoordinator,
      dependencyFactory: self)
  }
  
  public func makeSampleAuthData() -> SampleAuthRepository {
    let networkService = NetworkService()
    return SampleAuthRepositoryImp(networkService: networkService)
  }
  
  public func makeSampleSignInUsecase() -> SampleSignInUseCase {
    return SampleSignInUseCaseImp(sampleAuthRepository: makeSampleAuthData())
  }
  
  public func makeSampleSignUpUsecase() -> SampleSignUpUseCase {
    return SampleSignUpUseCaseImp(sampleAuthRepository: makeSampleAuthData())
  }
  public func makeSampleReactor(coordinator: any SampleAppCoordinator) -> any SampleReactor {
    let sampleSignInUseCase = makeSampleSignInUsecase()
    let sampleSignUpUseCase = makeSampleSignUpUsecase()
    return SampleReactorImp(
      coordinator: coordinator,
      sampleSignInUsecase: sampleSignInUseCase,
      sampleSignUpUsecase: sampleSignUpUseCase
    )
  }
  
  public func makeSampleViewController<T: SampleReactor>(reactor: T) -> any SampleViewController {
    return SampleViewControllerImp(reactor: reactor)
  }
}
