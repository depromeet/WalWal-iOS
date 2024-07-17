//
//  MissionDomainImplementation.swift
//
//  Mission
//
//  Created by 이지희 on .
//

import UIKit
import MissionData
import MissionDomain

import RxSwift

class MissionDomainImplementation: MissionDomainInterface {
  let repository: MissionDataInterface
  
  init(repository: MissionDataInterface) {
    self.repository = repository
  }
  
  func excute() {
    
  }
}

