//
//  FCMDependencyFactoryInterface.swift
//
//  FCM
//
//  Created by Jiyeon
//

import UIKit

import FCMDomain
import FCMData

public protocol FCMDependencyFactory {
  
  func injectFCMRepository() -> FCMRepository
  func injectFCMSaveUseCase() -> FCMSaveUseCase
  
}
