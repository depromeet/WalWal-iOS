//
//  MissionUploadDomainImplementation.swift
//
//  MissionUpload
//
//  Created by 조용인 on .
//

import UIKit
import MissionUploadData
import MissionUploadDomain

import RxSwift

class MissionUploadDomainImplementation: MissionUploadDomainInterface {
  let repository: MissionUploadDataInterface
  
  init(repository: MissionUploadDataInterface) {
    self.repository = repository
  }
  
  func excute() {
    
  }
}

