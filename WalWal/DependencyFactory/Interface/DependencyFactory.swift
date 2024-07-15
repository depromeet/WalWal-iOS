//
//  DependencyFactory.swift
//  DependencyFactory
//
//  Created by 조용인 on 7/10/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//
import UIKit

// MARK: - 추가되는 Feature에 따라 import되는 Interface를 작성해주세요.

import SampleData
import SampleDomain

public protocol DependencyFactory {
  
  // MARK: - 추가되는 Feature에 따라 Dependency를 생성 및 주입하는 함수를 추가해주새요
  
  func injectAuthData() -> SampleAuthRepository
  
  func injectSignInUsecase() -> SampleSignInUseCase
  func injectSignUpUsecase() -> SampleSignUpUseCase
}
