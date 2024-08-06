//
//  OnboardingDomainImplementation.swift
//
//  Onboarding
//
//  Created by Jiyeon on .
//

import UIKit
import OnboardingData
import OnboardingDomain

import RxSwift

class OnboardingDomainImplementation: OnboardingDomainInterface {
  let repository: OnboardingDataInterface
  
  init(repository: OnboardingDataInterface) {
    self.repository = repository
  }
  
  func excute() {
    
  }
}

