//
//  CommentDomainImplementation.swift
//
//  Comment
//
//  Created by 조용인 on .
//

import UIKit
import CommentData
import CommentDomain

import RxSwift

class CommentDomainImplementation: CommentDomainInterface {
  let repository: CommentDataInterface
  
  init(repository: CommentDataInterface) {
    self.repository = repository
  }
  
  func excute() {
    
  }
}

