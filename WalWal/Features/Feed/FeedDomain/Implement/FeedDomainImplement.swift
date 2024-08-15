//
//  FeedDomainImplementation.swift
//
//  Feed
//
//  Created by 이지희 on .
//

import UIKit
import FeedData
import FeedDomain

import RxSwift

class FeedDomainImplementation: FeedDomainInterface {
  let repository: FeedDataInterface
  
  init(repository: FeedDataInterface) {
    self.repository = repository
  }
  
  func excute() {
    
  }
}

