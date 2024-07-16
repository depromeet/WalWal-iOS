//
//  DependencyFactory.swift
//  DependencyFactory
//
//  Created by 조용인 on 7/10/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//
import UIKit

import BaseCoordinator
import SampleAppCoordinator
import SampleAuthCoordinator
import SampleHomeCoordinator

import SampleData
import SampleDomain
import SamplePresenter

public protocol DependencyFactory {
  
  // MARK: - 추가되는 Feature에 따라 Dependency를 생성 및 주입하는 함수를 추가해주새요
  
  func makeSampleAuthData() -> SampleAuthRepository
  
  func makeSampleSignInUsecase() -> SampleSignInUseCase
  func makeSampleSignUpUsecase() -> SampleSignUpUseCase
  
  func makeSampleAppCoordinator(navigationController: UINavigationController) -> any SampleAppCoordinator
  
  func makeSampleReactor(coordinator: any SampleAppCoordinator) -> any SampleReactor
  func makeSampleViewController<T: SampleReactor>(reactor: T) -> any SampleViewController
  
  
  func makeSampleAuthCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any SampleAuthCoordinator
  
  func makeSampleHomeCoordinator(navigationController: UINavigationController, parentCoordinator: any BaseCoordinator) -> any SampleHomeCoordinator
}
