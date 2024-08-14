//
//  FCMDependencyFactoryImplement.swift
//
//  FCM
//
//  Created by Jiyeon
//

import UIKit
import FCMDependencyFactory

import WalWalNetwork

import FCMData
import FCMDataImp
import FCMDomain
import FCMDomainImp

public class FCMDependencyFactoryImp: FCMDependencyFactory {
  
  public init() { }
  
  public func makeFCMData() -> FCMRepository {
    let networkService = NetworkService()
    return FCMRepositoryImp(networkService: networkService)
  }
  
  public func makeFCMSaveUseCase() -> FCMSaveUseCase {
    return FCMSaveUseCaseImp(fcmRepository: makeFCMData())
  }
  
}
