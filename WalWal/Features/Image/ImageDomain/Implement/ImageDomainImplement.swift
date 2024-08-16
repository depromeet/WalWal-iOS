//
//  ImageDomainImplementation.swift
//
//  Image
//
//  Created by 이지희 on .
//

import UIKit
import ImageData
import ImageDomain

import RxSwift

class ImageDomainImplementation: ImageDomainInterface {
  let repository: ImageDataInterface
  
  init(repository: ImageDataInterface) {
    self.repository = repository
  }
  
  func excute() {
    
  }
}

