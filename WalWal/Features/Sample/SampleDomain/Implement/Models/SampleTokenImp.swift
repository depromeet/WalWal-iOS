//
//  SampleTokenImp.swift
//  SampleDomainImp
//
//  Created by 조용인 on 7/17/24.
//  Copyright © 2024 olderStoneBed.io. All rights reserved.
//

import UIKit
import SampleData
import SampleDomain

public struct SampleTokenImp: SampleToken {
  public var token: String
  
  public init(dto: SampleSignUpDTO) {
    self.token = dto.token
  }
  
  public init(dto: SampleSignInDTO) {
    self.token = dto.token
  }
}
