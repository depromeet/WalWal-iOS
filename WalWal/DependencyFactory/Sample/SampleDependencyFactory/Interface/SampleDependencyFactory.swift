//
//  SampleDependencyFactoryInterface.swift
//
//  Sample
//
//  Created by 조용인
//

import UIKit
import BaseCoordinator
import SampleAppCoordinator
import SampleAuthCoordinator
import SampleHomeCoordinator

import SampleData
import SampleDomain
import SamplePresenter

public protocol SampleDependencyFactory {
  func makeSampleAppCoordinator(navigationController: UINavigationController) -> any SampleAppCoordinator
  func makeSampleAuthCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any SampleAuthCoordinator
  func makeSampleHomeCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any SampleHomeCoordinator
  func makeSampleAuthData() -> SampleAuthRepository
  
  func makeSampleSignInUsecase() -> SampleSignInUseCase
  func makeSampleSignUpUsecase() -> SampleSignUpUseCase
  
  func makeSampleReactor(coordinator: any SampleAppCoordinator) -> any SampleReactor
  func makeSampleViewController<T: SampleReactor>(reactor: T) -> any SampleViewController
}
