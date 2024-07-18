//
//  SplashDomainImplementation.swift
//
//  Splash
//
//  Created by 조용인 on .
//

import UIKit
import SplashData
import SplashDomain

import RxSwift

class SplashDomainImplementation: SplashDomainInterface {
  let repository: SplashDataInterface
  
  init(repository: SplashDataInterface) {
    self.repository = repository
  }
  
  func excute() {
    
  }
}

