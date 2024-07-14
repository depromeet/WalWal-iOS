//
//  AuthDomainImplementation.swift
//
//  Auth
//
//  Created by Jiyeon on .
//

import Foundation
import RxSwift

import AuthData
import AuthDomain

class AuthDomainImplementation: AuthDomainInterface {
  let repository: AuthDataInterface
  
  init(repository: AuthDataInterface) {
    self.repository = repository
  }
  
  func excute() {
    
  }
}

