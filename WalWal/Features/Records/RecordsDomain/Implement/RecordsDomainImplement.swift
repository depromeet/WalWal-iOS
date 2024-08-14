//
//  RecordsDomainImplementation.swift
//
//  Records
//
//  Created by 조용인 on .
//

import UIKit
import RecordsData
import RecordsDomain

import RxSwift

class RecordsDomainImplementation: RecordsDomainInterface {
  let repository: RecordsDataInterface
  
  init(repository: RecordsDataInterface) {
    self.repository = repository
  }
  
  func excute() {
    
  }
}

