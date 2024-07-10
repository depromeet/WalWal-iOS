//
//  DependencyFactory.swift
//  DependencyFactory
//
//  Created by 조용인 on 7/10/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//
import Foundation
import UIKit
// MARK: - 추가되는 Feature에 따라 import되는 Interface를 작성해주세요. 
// (이곳은 Interface만 의존성을 갖습니다.)
// Ex.
// import AuthDomain
// import AuthData
// 등등...


public protocol DependencyFactory {
  // MARK: - 추가되는 Feature에 따라 Dependency를 생성 및 주입하는 함수를 추가해주새요
  /*
  public func injectAuthData() -> AuthData
  public func injectAuthDomain() -> AuthDomain
   */
}
