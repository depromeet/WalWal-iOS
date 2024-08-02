//
//  MyPageDomainImplementation.swift
//
//  MyPage
//
//  Created by 조용인 on .
//

import UIKit
import MyPageData
import MyPageDomain

import RxSwift

class MyPageDomainImplementation: MyPageDomainInterface {
  let repository: MyPageDataInterface
  
  init(repository: MyPageDataInterface) {
    self.repository = repository
  }
  
  func excute() {
    
  }
}

